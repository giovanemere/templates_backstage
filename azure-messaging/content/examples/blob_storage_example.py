#!/usr/bin/env python3
"""
Ejemplo de uso de Azure Blob Storage para ${{ values.name }}
Requiere: pip install azure-storage-blob
"""

import json
from datetime import datetime
from azure.storage.blob import BlobServiceClient, BlobClient

# Configuración (obtener desde terraform output)
CONNECTION_STRING = "your_storage_connection_string_here"
CONTAINER_NAME = "${{ values.name }}-container"

def upload_blob():
    """Subir un archivo al blob storage"""
    try:
        # Crear cliente del servicio
        blob_service_client = BlobServiceClient.from_connection_string(CONNECTION_STRING)
        
        # Datos de ejemplo
        data = {
            "project": "${{ values.name }}",
            "timestamp": datetime.now().isoformat(),
            "message": "Hello from Blob Storage!",
            "version": "1.0"
        }
        
        blob_name = f"data/{datetime.now().strftime('%Y/%m/%d')}/sample-{datetime.now().strftime('%H%M%S')}.json"
        
        # Subir el blob
        blob_client = blob_service_client.get_blob_client(
            container=CONTAINER_NAME, 
            blob=blob_name
        )
        
        blob_client.upload_blob(
            data=json.dumps(data, indent=2),
            content_type="application/json",
            overwrite=True
        )
        
        print(f"✅ Blob subido: {blob_name}")
        return blob_name
        
    except Exception as e:
        print(f"❌ Error subiendo blob: {e}")
        return None

def list_blobs():
    """Listar blobs en el contenedor"""
    try:
        blob_service_client = BlobServiceClient.from_connection_string(CONNECTION_STRING)
        container_client = blob_service_client.get_container_client(CONTAINER_NAME)
        
        print("📋 Blobs en el contenedor:")
        blob_list = container_client.list_blobs()
        
        for blob in blob_list:
            print(f"   - {blob.name}")
            print(f"     Tamaño: {blob.size} bytes")
            print(f"     Modificado: {blob.last_modified}")
            print()
            
    except Exception as e:
        print(f"❌ Error listando blobs: {e}")

def download_blob(blob_name):
    """Descargar un blob"""
    try:
        blob_service_client = BlobServiceClient.from_connection_string(CONNECTION_STRING)
        blob_client = blob_service_client.get_blob_client(
            container=CONTAINER_NAME, 
            blob=blob_name
        )
        
        download_data = blob_client.download_blob().readall()
        data = json.loads(download_data.decode('utf-8'))
        
        print(f"📥 Blob descargado: {blob_name}")
        print(f"   Contenido: {json.dumps(data, indent=2)}")
        
    except Exception as e:
        print(f"❌ Error descargando blob: {e}")

def main():
    """Función principal"""
    print("🚀 Ejemplo de Azure Blob Storage")
    print("=" * 40)
    
    # Subir un blob
    blob_name = upload_blob()
    
    # Listar blobs
    list_blobs()
    
    # Descargar el blob que acabamos de subir
    if blob_name:
        download_blob(blob_name)

if __name__ == "__main__":
    main()
