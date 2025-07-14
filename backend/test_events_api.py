import requests
import json

base_url = "http://localhost:8000/api/v1/events"

def test_hot_events():
    print("🔥 Testing Hot Events API:")
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

def test_monthly_events():
    print("📅 Testing Monthly Events API (August 2025):")
    try:
        response = requests.get(f"{base_url}/monthly?year=2025&month=8")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            monthly_events = response.json()
            print(f"   📊 Found {len(monthly_events)} events in August 2025:")
            for event in monthly_events:
                print(f"      - {event['Title']} ({event['StartTime'][:10]})")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_upcoming_events():
    print("⏰ Testing Upcoming Events API (next 30 days):")
    try:
        response = requests.get(f"{base_url}/upcoming?days=30&limit=10")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            upcoming_events = response.json()
            print(f"   📊 Found {len(upcoming_events)} upcoming events:")
            for event in upcoming_events:
                print(f"      - {event['Title']} ({event['StartTime'][:10]})")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_search_events():
    print("🔍 Testing Search Events API:")
    try:
        response = requests.get(f"{base_url}/search?q=music&limit=5")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            search_results = response.json()
            print(f"   📊 Found {len(search_results)} events with 'music':")
            for event in search_results:
                print(f"      - {event['Title']} ({event['Category']})")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_all_events():
    print("📋 Testing Get All Events API:")
    try:
        response = requests.get(f"{base_url}/")
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            events = response.json()
            print(f"   📊 Total events in database: {len(events)}")
            if events:
                print("   Recent events:")
                for event in events[:3]:  # Show first 3 events
                    print(f"      - {event['EventID']}: {event['Title']} ({event['Category']}) - {event['Status']}")
            else:
                print("   ℹ️  No events found in database")
        else:
            print(f"   Error: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

def test_event_tickets():
    print("🎫 Testing Event Tickets API:")
    try:
        # First get an event ID
        response = requests.get(f"{base_url}/")
        if response.status_code == 200:
            events = response.json()
            if events:
                event_id = events[0]['EventID']
                response = requests.get(f"{base_url}/{event_id}/tickets")
                print(f"   Status: {response.status_code}")
                if response.status_code == 200:
                    tickets = response.json()
                    print(f"   📊 Found {len(tickets)} tickets for event {event_id}")
                else:
                    print(f"   Error: {response.text}")
            else:
                print("   ℹ️  No events available to test tickets")
        else:
            print(f"   Error getting events: {response.text}")
    except Exception as e:
        print(f"   ❌ Error: {e}")
    print()

if __name__ == "__main__":
    print("🧪 Event Manager API Testing")
    print("=" * 40)
    
    # Test basic endpoint first
    test_all_events()
    
    # Test new endpoints
    test_hot_events()
    test_monthly_events()
    test_upcoming_events()
    test_search_events()
    test_event_tickets()
    
    print("🎉 API Testing completed!")
    print("\n📚 Available API Endpoints:")
    print("- GET /api/v1/events/                    # Get all events")
    print("- GET /api/v1/events/hot?limit=10        # Get hot events")
    print("- GET /api/v1/events/monthly?year=2025&month=8  # Get events by month")
    print("- GET /api/v1/events/upcoming?days=30    # Get upcoming events")
    print("- GET /api/v1/events/search?q=music     # Search events")
    print("- GET /api/v1/events/{id}/tickets       # Get event tickets")
    print("\n🌐 FastAPI Docs: http://localhost:8000/docs")
