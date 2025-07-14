import requests
import json

def create_sample_user():
    """Create a sample user to be organizer"""
    print("👤 Creating sample organizer user...")
    
    user_data = {
        "email": "organizer@example.com",
        "FullName": "John Smith",
        "Password": "password123",
        "Address": "123 Main Street, City",
        "Phone": "+1234567890"
    }
    
    try:
        response = requests.post("http://localhost:8000/api/v1/users/", json=user_data)
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"   ✅ Created user: {result['FullName']} (ID: {result['UserID']})")
            return result['UserID']
        else:
            print(f"   Error: {response.text}")
            return None
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return None

def test_with_user():
    """Test with created user"""
    user_id = create_sample_user()
    
    if user_id:
        print(f"\n🧪 Testing with User ID: {user_id}")
        
        # Test get event with organizer
        print("\n👤 Testing Event with Organizer:")
        try:
            response = requests.get(f"http://localhost:8000/api/v1/events/1/with-organizer")
            print(f"   Status: {response.status_code}")
            if response.status_code == 200:
                data = response.json()
                print(f"   Event: {data['Title']}")
                print(f"   Organizer: {data['Organizer']['FullName']} ({data['Organizer']['email']})")
            else:
                print(f"   Error: {response.text}")
        except Exception as e:
            print(f"   ❌ Error: {e}")
        
        # Test get events by organizer
        print("\n🏢 Testing Events by Organizer:")
        try:
            response = requests.get(f"http://localhost:8000/api/v1/events/by-organizer/{user_id}")
            print(f"   Status: {response.status_code}")
            if response.status_code == 200:
                events = response.json()
                print(f"   📊 Found {len(events)} events by organizer {user_id}")
                for event in events:
                    print(f"      - {event['Title']} ({event['Status']})")
            else:
                print(f"   Error: {response.text}")
        except Exception as e:
            print(f"   ❌ Error: {e}")

if __name__ == "__main__":
    print("🚀 Creating User and Testing Organizer APIs")
    print("=" * 50)
    test_with_user()
