import requests
import json

base_url = "http://localhost:8000/api/v1/events"

def get_all_events():
    """Get all events to see current status"""
    print("📋 Current Events in Database:")
    try:
        response = requests.get(f"{base_url}/")
        if response.status_code == 200:
            events = response.json()
            for event in events:
                print(f"   - ID: {event['EventID']}, Title: {event['Title']}")
                print(f"     Status: {event['Status']}, Organizer ID: {event['OrganizerID']}")
            print()
            return events
        else:
            print(f"   ❌ Error: {response.text}")
            return []
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return []

def test_event_with_organizer(event_id):
    """Test getting event with organizer info"""
    print(f"👤 Testing Event with Organizer (Event ID: {event_id}):")
    try:
        response = requests.get(f"{base_url}/{event_id}/with-organizer")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Event: {data['Title']}")
            print(f"   Organizer: {data['Organizer']['FullName']} ({data['Organizer']['email']})")
            if data['Organizer']['Phone']:
                print(f"   Phone: {data['Organizer']['Phone']}")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_update_status(event_id, new_status):
    """Test updating event status"""
    print(f"🔄 Testing Status Update (Event ID: {event_id} -> {new_status}):")
    try:
        data = {"Status": new_status}
        response = requests.patch(f"{base_url}/{event_id}/status", json=data)
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"   ✅ Updated: {result['Title']} -> Status: {result['Status']}")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_events_by_organizer(organizer_id):
    """Test getting events by organizer"""
    print(f"🏢 Testing Events by Organizer (Organizer ID: {organizer_id}):")
    try:
        response = requests.get(f"{base_url}/by-organizer/{organizer_id}")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            events = response.json()
            print(f"   📊 Found {len(events)} events by organizer {organizer_id}:")
            for event in events:
                print(f"      - {event['Title']} ({event['Status']})")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_bulk_publish(event_ids):
    """Test bulk publishing events"""
    print(f"📢 Testing Bulk Publish (Event IDs: {event_ids}):")
    try:
        response = requests.post(f"{base_url}/bulk-publish", json=event_ids)
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"   ✅ {result['message']}")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_hot_events():
    """Test hot events after publishing"""
    print("🔥 Testing Hot Events (after publishing):")
    try:
        response = requests.get(f"{base_url}/hot?limit=5")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            hot_events = response.json()
            print(f"   📊 Found {len(hot_events)} hot events:")
            for event in hot_events:
                print(f"      - {event['Title']} (Capacity: {event['Capacity']})")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

if __name__ == "__main__":
    print("🧪 Event Manager - Organizer & Status Testing")
    print("=" * 50)
    
    # 1. Lấy danh sách events hiện tại
    events = get_all_events()
    
    if not events:
        print("❌ No events found. Please create some events first.")
        exit()
    
    # 2. Test lấy event với thông tin organizer
    first_event_id = events[0]['EventID']
    test_event_with_organizer(first_event_id)
    
    # 3. Test lấy events theo organizer
    organizer_id = events[0]['OrganizerID']
    test_events_by_organizer(organizer_id)
    
    # 4. Test update status từng event (draft -> published)
    draft_events = [e for e in events if e['Status'] == 'draft']
    if draft_events:
        print("🔄 Publishing draft events one by one:")
        for event in draft_events[:2]:  # Publish first 2 draft events
            test_update_status(event['EventID'], "published")
    
    # 5. Test bulk publish (nếu còn draft events)
    remaining_draft = [e for e in events if e['Status'] == 'draft'][2:]  # Skip first 2
    if remaining_draft:
        draft_ids = [e['EventID'] for e in remaining_draft]
        test_bulk_publish(draft_ids)
    
    # 6. Test hot events sau khi publish
    test_hot_events()
    
    # 7. Kiểm tra lại tất cả events
    print("📋 Final Events Status:")
    get_all_events()
    
    print("🎉 Testing completed!")
    print("\n📚 New API Endpoints:")
    print("- GET /api/v1/events/{id}/with-organizer    # Get event with organizer info")
    print("- PATCH /api/v1/events/{id}/status          # Update event status")
    print("- GET /api/v1/events/by-organizer/{id}      # Get events by organizer")
    print("- POST /api/v1/events/bulk-publish          # Bulk publish events")
