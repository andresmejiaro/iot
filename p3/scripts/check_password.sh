#!/bin/bash

echo "⏳ Esperando a que ArgoCD genere la contraseña..."

while true; do
  # Intenta obtener la contraseña
  ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath='{.data.password}' 2>&1)

  # Si la salida contiene "Error" → reintenta
  if echo "$ARGOCD_PWD" | grep -q "Error"; then
    echo "❌ Aún no disponible, reintentando en 5s..."
    sleep 5
    continue
  fi

  # Si está vacío → también reintenta
  if [ -z "$ARGOCD_PWD" ]; then
    echo "⚠️ Vacío, esperando..."
    sleep 5
    continue
  fi

  # Si llega aquí, decodifica y muestra la password
  ARGOCD_PWD=$(echo "$ARGOCD_PWD" | base64 --decode 2>/dev/null)

  if [ -n "$ARGOCD_PWD" ]; then
    echo "✅ La contraseña de ArgoCD es: $ARGOCD_PWD"
    break
  else
    echo "⚠️ Error al decodificar, reintentando..."
    sleep 5
  fi
done
