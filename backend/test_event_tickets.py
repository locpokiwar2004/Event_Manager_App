import requests
import json

def test_event_tickets():
    """Test API lấy tickets cho event cụ thể"""
    
    # Test với EventID = 1 (Summer Music Festival 2025)
    event_id = 1
    url = f"http://localhost:8000/api/v1/events/{event_id}/tickets"
    
    print(f"Testing tickets for Event ID: {event_id}")
    print(f"URL: {url}")
    
    try:
        response = requests.get(url)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            tickets = response.json()
            print(f"Response: {json.dumps(tickets, indent=2)}")
            print(f"✅ Found {len(tickets)} tickets for event {event_id}")
            
            for ticket in tickets:
                print(f"  - {ticket['Name']}: ${ticket['Price']} (Available: {ticket['QuantityTotal'] - ticket['QuantitySold']}/{ticket['QuantityTotal']}, Max per person: {ticket['OnePer']})")
        else:
            print(f"❌ Failed to get tickets: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")

def test_all_tickets():
    """Test API lấy tất cả tickets"""
    url = "http://localhost:8000/api/v1/tickets/"
    
    print(f"\nTesting all tickets")
    print(f"URL: {url}")
    
    try:
        response = requests.get(url)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            tickets = response.json()
            print(f"✅ Found {len(tickets)} total tickets")
            
            # Group by EventID
            events = {}
            for ticket in tickets:
                event_id = ticket['EventID']
                if event_id not in events:
                    events[event_id] = []
                events[event_id].append(ticket)
            
            print(f"Tickets grouped by Event:")
            for event_id, event_tickets in events.items():
                print(f"  Event {event_id}: {len(event_tickets)} tickets")
                for ticket in event_tickets:
                    available = ticket['QuantityTotal'] - ticket['QuantitySold']
                    print(f"    - {ticket['Name']}: ${ticket['Price']} (Available: {available}/{ticket['QuantityTotal']}, Max: {ticket['OnePer']})")
        else:
            print(f"❌ Failed to get all tickets: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    print("=== Testing Ticket API ===")
    test_event_tickets()
    test_all_tickets()
    print("\n=== Test completed ===")
