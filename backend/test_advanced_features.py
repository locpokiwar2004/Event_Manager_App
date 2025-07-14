import requests
import json

base_url = "http://localhost:8000/api/v1"

def test_status_transitions():
    """Test các status transitions hợp lệ và không hợp lệ"""
    print("🔄 Testing Status Transitions:")
    
    # 1. Thử chuyển từ published -> draft (should fail)
    print("   1. Testing published -> draft (should fail):")
    try:
        response = requests.patch(f"{base_url}/events/1/status", 
                                json={"Status": "draft"})
        print(f"      Status: {response.status_code}")
        if response.status_code != 200:
            print(f"      ✅ Correctly rejected: {response.json()['detail']}")
        else:
            print(f"      ❌ Should have failed")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    
    # 2. Thử chuyển từ published -> cancelled (should succeed)
    print("   2. Testing published -> cancelled (should succeed):")
    try:
        response = requests.patch(f"{base_url}/events/2/status", 
                                json={"Status": "cancelled"})
        print(f"      Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"      ✅ Success: {result['Title']} -> {result['Status']}")
        else:
            print(f"      ❌ Failed: {response.text}")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    
    # 3. Thử chuyển từ cancelled -> published (should fail)
    print("   3. Testing cancelled -> published (should fail):")
    try:
        response = requests.patch(f"{base_url}/events/2/status", 
                                json={"Status": "published"})
        print(f"      Status: {response.status_code}")
        if response.status_code != 200:
            print(f"      ✅ Correctly rejected: {response.json()['detail']}")
        else:
            print(f"      ❌ Should have failed")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    print()

def test_organizer_details():
    """Test lấy thông tin chi tiết organizer"""
    print("👤 Testing Organizer Details:")
    try:
        response = requests.get(f"{base_url}/events/1/with-organizer")
        if response.status_code == 200:
            data = response.json()
            print(f"   Event: {data['Title']}")
            print(f"   Category: {data['Category']}")
            print(f"   Location: {data['Location']}")
            print(f"   Capacity: {data['Capacity']}")
            print(f"   Status: {data['Status']}")
            print(f"   Start: {data['StartTime']}")
            print(f"   End: {data['EndTime']}")
            print(f"   Organizer:")
            org = data['Organizer']
            print(f"      - Name: {org['FullName']}")
            print(f"      - Email: {org['email']}")
            print(f"      - Phone: {org.get('Phone', 'N/A')}")
            print(f"      - Address: {org.get('Address', 'N/A')}")
        else:
            print(f"   ❌ Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_monthly_events():
    """Test lấy events theo tháng với filter"""
    print("📅 Testing Monthly Events with Filters:")
    
    # Test tháng 8 với status published
    print("   1. August 2025 - Published events:")
    try:
        response = requests.get(f"{base_url}/events/monthly?year=2025&month=8&status=published")
        if response.status_code == 200:
            events = response.json()
            print(f"      Found {len(events)} published events in August 2025:")
            for event in events:
                print(f"         - {event['Title']} ({event['StartTime'][:10]})")
        else:
            print(f"      ❌ Error: {response.text}")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    
    # Test tháng 8 với category Music
    print("   2. August 2025 - Music category:")
    try:
        response = requests.get(f"{base_url}/events/monthly?year=2025&month=8&category=music")
        if response.status_code == 200:
            events = response.json()
            print(f"      Found {len(events)} music events in August 2025:")
            for event in events:
                print(f"         - {event['Title']} ({event['Category']})")
        else:
            print(f"      ❌ Error: {response.text}")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    print()

def test_search_advanced():
    """Test search với nhiều filters"""
    print("🔍 Testing Advanced Search:")
    
    # Search by location
    print("   1. Search by location 'park':")
    try:
        response = requests.get(f"{base_url}/events/search?q=park&limit=5")
        if response.status_code == 200:
            events = response.json()
            print(f"      Found {len(events)} events with 'park':")
            for event in events:
                print(f"         - {event['Title']} ({event['Location']})")
        else:
            print(f"      ❌ Error: {response.text}")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    
    # Search by category with status filter
    print("   2. Search 'tech' with published status:")
    try:
        response = requests.get(f"{base_url}/events/search?q=tech&status=published")
        if response.status_code == 200:
            events = response.json()
            print(f"      Found {len(events)} published tech events:")
            for event in events:
                print(f"         - {event['Title']} ({event['Status']})")
        else:
            print(f"      ❌ Error: {response.text}")
    except Exception as e:
        print(f"      ❌ Error: {e}")
    print()

def test_all_users():
    """Test lấy danh sách users (để thấy organizers)"""
    print("👥 Testing Get All Users:")
    try:
        response = requests.get(f"{base_url}/users/")
        if response.status_code == 200:
            users = response.json()
            print(f"   Found {len(users)} users:")
            for user in users:
                print(f"      - ID: {user['UserID']}, Name: {user['FullName']}, Email: {user['email']}")
        else:
            print(f"   ❌ Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

if __name__ == "__main__":
    print("🚀 Advanced Event Manager API Testing")
    print("=" * 50)
    
    # Test status transitions
    test_status_transitions()
    
    # Test organizer details
    test_organizer_details()
    
    # Test monthly events with filters
    test_monthly_events()
    
    # Test advanced search
    test_search_advanced()
    
    # Test users list
    test_all_users()
    
    print("🎉 Advanced testing completed!")
    print("\n📋 Summary of Features:")
    print("✅ Status transitions with validation")
    print("✅ Event with organizer information") 
    print("✅ Monthly events with filters")
    print("✅ Advanced search with multiple criteria")
    print("✅ Events by organizer")
    print("✅ Bulk publish events")
    print("✅ Hot events ranking")
    print("✅ Upcoming events")
    
    print("\n📚 Quick Reference:")
    print("- Update status: PATCH /api/v1/events/{id}/status")
    print("- Get with organizer: GET /api/v1/events/{id}/with-organizer")
    print("- Events by organizer: GET /api/v1/events/by-organizer/{id}")
    print("- Monthly filter: GET /api/v1/events/monthly?year=2025&month=8&status=published")
    print("- Search filter: GET /api/v1/events/search?q=music&status=published")
