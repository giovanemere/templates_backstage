#!/usr/bin/env python3
"""
Ejemplo de uso de Azure Service Bus para ${{ values.name }}
Requiere: pip install azure-servicebus azure-storage-blob
"""

import asyncio
import json
from datetime import datetime
from azure.servicebus.aio import ServiceBusClient
from azure.servicebus import ServiceBusMessage

# Configuración (obtener desde terraform output)
CONNECTION_STRING = "your_service_bus_connection_string_here"
QUEUE_NAME = "${{ values.name }}-queue"

async def send_message():
    """Enviar un mensaje a la cola"""
    async with ServiceBusClient.from_connection_string(CONNECTION_STRING) as client:
        sender = client.get_queue_sender(queue_name=QUEUE_NAME)
        
        message_data = {
            "id": "msg-001",
            "timestamp": datetime.now().isoformat(),
            "project": "${{ values.name }}",
            "data": "Hello from Service Bus!",
            "priority": "high"
        }
        
        message = ServiceBusMessage(
            body=json.dumps(message_data),
            content_type="application/json",
            message_id=message_data["id"]
        )
        
        async with sender:
            await sender.send_messages(message)
            print(f"✅ Mensaje enviado: {message_data['id']}")

async def receive_messages():
    """Recibir mensajes de la cola"""
    async with ServiceBusClient.from_connection_string(CONNECTION_STRING) as client:
        receiver = client.get_queue_receiver(queue_name=QUEUE_NAME)
        
        async with receiver:
            received_msgs = await receiver.receive_messages(max_message_count=10, max_wait_time=5)
            
            for msg in received_msgs:
                print(f"📨 Mensaje recibido: {msg.message_id}")
                print(f"   Contenido: {str(msg)}")
                print(f"   Propiedades: {msg.application_properties}")
                
                # Completar el mensaje (removerlo de la cola)
                await receiver.complete_message(msg)
                print(f"✅ Mensaje procesado: {msg.message_id}")

async def main():
    """Función principal"""
    print("🚀 Ejemplo de Azure Service Bus")
    print("=" * 40)
    
    try:
        print("📤 Enviando mensaje...")
        await send_message()
        
        print("\n📥 Recibiendo mensajes...")
        await receive_messages()
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
