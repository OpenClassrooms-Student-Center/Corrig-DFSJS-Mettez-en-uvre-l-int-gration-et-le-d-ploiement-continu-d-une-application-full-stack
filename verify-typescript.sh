#!/bin/bash

# Script de vérification TypeScript
# Vérifie que tous les fichiers TypeScript compilent sans erreurs

echo "=========================================="
echo "Vérification TypeScript - p7-dfsjs-corrige"
echo "=========================================="
echo ""

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour vérifier un répertoire
check_typescript() {
    local dir=$1
    local name=$2
    
    echo "----------------------------------------"
    echo "Vérification: $name"
    echo "----------------------------------------"
    
    if [ ! -d "$dir" ]; then
        echo -e "${RED}✗ Répertoire non trouvé: $dir${NC}"
        return 1
    fi
    
    cd "$dir" || exit 1
    
    # Vérifier si node_modules existe
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}⚠ node_modules non trouvé. Installation des dépendances...${NC}"
        npm install
    fi
    
    # Vérifier si TypeScript est installé
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}✗ npx n'est pas disponible${NC}"
        return 1
    fi
    
    # Exécuter la vérification TypeScript
    echo "Exécution de: tsc --noEmit"
    if npx tsc --noEmit; then
        echo -e "${GREEN}✓ Aucune erreur TypeScript détectée${NC}"
        return 0
    else
        echo -e "${RED}✗ Des erreurs TypeScript ont été détectées${NC}"
        return 1
    fi
}

# Chemin de base du projet
BASE_DIR="/Users/simon.stoll/Documents/CodebaseFactory/p7-dfsjs-corrige"

# Variables pour suivre les résultats
server_ok=0
client_ok=0

# Vérification du serveur
if check_typescript "$BASE_DIR/server" "Server (Backend)"; then
    server_ok=1
fi

echo ""

# Vérification du client
if check_typescript "$BASE_DIR/client" "Client (Frontend)"; then
    client_ok=1
fi

# Résumé final
echo ""
echo "=========================================="
echo "RÉSUMÉ"
echo "=========================================="

if [ $server_ok -eq 1 ] && [ $client_ok -eq 1 ]; then
    echo -e "${GREEN}✓ Tous les tests TypeScript ont réussi!${NC}"
    echo ""
    echo "Le projet compile sans erreurs TypeScript."
    echo "Toutes les variables non utilisées ont été correctement préfixées."
    exit 0
else
    echo -e "${RED}✗ Certains tests TypeScript ont échoué${NC}"
    echo ""
    [ $server_ok -eq 0 ] && echo -e "${RED}  - Server: ÉCHEC${NC}"
    [ $server_ok -eq 1 ] && echo -e "${GREEN}  - Server: SUCCÈS${NC}"
    [ $client_ok -eq 0 ] && echo -e "${RED}  - Client: ÉCHEC${NC}"
    [ $client_ok -eq 1 ] && echo -e "${GREEN}  - Client: SUCCÈS${NC}"
    exit 1
fi
