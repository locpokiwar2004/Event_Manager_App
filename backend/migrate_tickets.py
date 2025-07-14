"""
Migration script để thêm trường QuantitySold cho các tickets hiện có
"""
import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

MONGODB_URL = "mongodb://localhost:27017"
DATABASE_NAME = "event_management"

async def migrate_tickets():
    """Thêm trường QuantitySold = 0 cho tất cả tickets không có trường này"""
    client = AsyncIOMotorClient(MONGODB_URL)
    db = client[DATABASE_NAME]
    
    try:
        # Tìm tất cả tickets không có trường QuantitySold
        tickets_without_quantity_sold = await db.tickets.find(
            {"QuantitySold": {"$exists": False}}
        ).to_list(1000)
        
        logger.info(f"Found {len(tickets_without_quantity_sold)} tickets without QuantitySold field")
        
        if tickets_without_quantity_sold:
            # Cập nhật tất cả tickets này
            result = await db.tickets.update_many(
                {"QuantitySold": {"$exists": False}},
                {"$set": {"QuantitySold": 0}}
            )
            
            logger.info(f"Updated {result.modified_count} tickets with QuantitySold = 0")
        else:
            logger.info("All tickets already have QuantitySold field")
            
    except Exception as e:
        logger.error(f"Error during migration: {str(e)}")
    finally:
        client.close()

if __name__ == "__main__":
    asyncio.run(migrate_tickets())
