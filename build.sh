


APP_CONFIG_PATH="./build.config"
TEMPLATE_SPEC_PATH="BxObjC.podspec"
WORK_SPEC_PATH="BxObjCtemp.podspec"
VAR_NAME="VERSION_NUMBER"


# Create execution

checkExit(){
    if [ $? != 0 ]; then
    echo "Building failed\n"
    exit 1
    fi
}

tag(){
	git tag -f -a "${VERSION_NUMBER}" -m build
	git push -f --tags
}

# Load Config

if [[ "$1" != "" ]]
    then
    	CUSTOM_BUILD=1
        echo "VERSION_NUMBER=$1" > "$APP_CONFIG_PATH"
    fi
. "$APP_CONFIG_PATH"


cp  -rf "${TEMPLATE_SPEC_PATH}" "${WORK_SPEC_PATH}"
checkExit
sed -i -e "s/$VAR_NAME/$VERSION_NUMBER/" "${WORK_SPEC_PATH}"
checkExit
tag
checkExit
pod trunk push "${WORK_SPEC_PATH}" --allow-warnings --verbose
checkExit
rm -f -d "${WORK_SPEC_PATH}"
rm -f -d "${WORK_SPEC_PATH}-e"

