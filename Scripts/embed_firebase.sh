FILE="App/Project/${APP_ENVIRONMENT}/GoogleService-Info.plist"

if [ -f "$FILE" ]; then
    cp "${FILE}" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
else 
    echo "GoogleService-Info.plist not found at ${FILE}. Check your xcconfig for a correct APP_ENVIRONMENT value"
    exit 1
fi