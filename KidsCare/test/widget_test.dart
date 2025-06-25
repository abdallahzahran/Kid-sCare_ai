// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidscare/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kidscare/core/services/kids_service.dart';
import 'package:kidscare/core/cache/cache_helper.dart';
import 'package:kidscare/core/cache/cache_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Clear SharedPreferences before each test
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  testWidgets('App should start with ChooseUserView', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app is built
    expect(find.byType(MyApp), findsOneWidget);
  });

  test('KidsService should store and retrieve kids correctly', () async {
    final kidsService = KidsService();
    
    // Set user email
    await kidsService.setUserEmail('test@example.com');
    
    // Add a kid
    await kidsService.addKid({
      'name': 'Test Kid',
      'email': 'kid@example.com',
      'age': '10'
    });

    // Clear the service
    kidsService.clearAll();

    // Reload data
    await kidsService.loadFromCache();

    // Verify data is loaded correctly
    expect(kidsService.kids.length, 1);
    expect(kidsService.kids[0]['name'], 'Test Kid');
  });

  test('KidsService should handle multiple users', () async {
    final kidsService = KidsService();
    
    // First user
    await kidsService.setUserEmail('user1@example.com');
    await kidsService.addKid({
      'name': 'Kid 1',
      'email': 'kid1@example.com',
      'age': '10'
    });

    // Second user
    await kidsService.setUserEmail('user2@example.com');
    await kidsService.addKid({
      'name': 'Kid 2',
      'email': 'kid2@example.com',
      'age': '12'
    });

    // Switch back to first user
    await kidsService.setUserEmail('user1@example.com');
    expect(kidsService.kids.length, 1);
    expect(kidsService.kids[0]['name'], 'Kid 1');

    // Switch to second user
    await kidsService.setUserEmail('user2@example.com');
    expect(kidsService.kids.length, 1);
    expect(kidsService.kids[0]['name'], 'Kid 2');
  });

  test('KidsService should handle first kid index correctly', () async {
    final kidsService = KidsService();
    await kidsService.setUserEmail('test@example.com');
    
    // Add multiple kids
    await kidsService.addKid({
      'name': 'Kid 1',
      'email': 'kid1@example.com',
      'age': '10'
    });
    await kidsService.addKid({
      'name': 'Kid 2',
      'email': 'kid2@example.com',
      'age': '12'
    });

    // Update first kid index
    await kidsService.updateFirstKid(1);
    expect(kidsService.firstKidIndex, 1);
    expect(kidsService.getFirstKid()?['name'], 'Kid 2');
  });

  test('KidsService should handle kid deletion correctly', () async {
    final kidsService = KidsService();
    await kidsService.setUserEmail('test@example.com');
    
    // Add two kids
    await kidsService.addKid({
      'name': 'Kid 1',
      'email': 'kid1@example.com',
      'age': '10'
    });
    await kidsService.addKid({
      'name': 'Kid 2',
      'email': 'kid2@example.com',
      'age': '12'
    });

    // Try to delete first kid
    expect(kidsService.canDeleteKid(0), true);
    await kidsService.deleteKid(0);
    expect(kidsService.kids.length, 1);
    expect(kidsService.kids[0]['name'], 'Kid 2');

    // Try to delete last kid (should not be allowed)
    expect(kidsService.canDeleteKid(0), false);
  });

  test('CacheHelper should persist data correctly', () async {
    // Test String
    await CacheHelper.saveData(key: 'test_string', value: 'test');
    expect(CacheHelper.getData(key: 'test_string'), 'test');

    // Test int
    await CacheHelper.saveData(key: 'test_int', value: 123);
    expect(CacheHelper.getData(key: 'test_int'), 123);

    // Test bool
    await CacheHelper.saveData(key: 'test_bool', value: true);
    expect(CacheHelper.getData(key: 'test_bool'), true);

    // Test double
    await CacheHelper.saveData(key: 'test_double', value: 123.45);
    expect(CacheHelper.getData(key: 'test_double'), 123.45);
  });
}
