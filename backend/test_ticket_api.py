import requests
import json

# Test tạo ticket mới
def test_create_ticket():
    url = "http://localhost:8000/api/v1/tickets/"
    
    # Data để tạo ticket mới
    ticket_data = {
        "EventID": 1,
        "Name": "VIP Ticket",
        "Price": 500000.0,
        "OnePer": 2,
        "QuantityTotal": 100
    }
    
    print("Testing ticket creation...")
    print(f"URL: {url}")
    print(f"Data: {json.dumps(ticket_data, indent=2)}")
    
    try:
        response = requests.post(url, json=ticket_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            print("✅ Ticket created successfully!")
            return response.json()
        else:
            print("❌ Failed to create ticket")
            return None
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return None

# Test lấy danh sách tickets
def test_get_tickets():
    url = "http://localhost:8000/api/v1/tickets/"
    
    print("\nTesting get tickets...")
    print(f"URL: {url}")
    
    try:
        response = requests.get(url)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            print("✅ Tickets retrieved successfully!")
            return response.json()
        else:
            print("❌ Failed to get tickets")
            return None
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return None

if __name__ == "__main__":
    print("=== Testing Ticket API ===")
    
    # Test tạo ticket
    created_ticket = test_create_ticket()
    
    # Test lấy danh sách tickets
    tickets = test_get_tickets()
    
    print("\n=== Test completed ===")
