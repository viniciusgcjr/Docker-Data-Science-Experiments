# Input validation

NOAA_SATELLITE_NAME=${NOAA_SATELLITE_NAME:?"You need provide the satellite name such as goes16"} 
NOAA_ABI_PRODUCT_NAME=${NOAA_ABI_PRODUCT_NAME:?"You need provide the ABI product name such as ABI-L1b-RadC"} 
IMAGE_RETRIEVAL_YEAR=${IMAGE_RETRIEVAL_YEAR:?"You need provide the image retrieval year (YYYY format)"} 
IMAGE_RETRIEVAL_JULIAN_DAY=${IMAGE_RETRIEVAL_JULIAN_DAY:?"You need provide the image retrieval day (julian format: 1-366"} 
IMAGE_RETRIEVAL_HOUR=${IMAGE_RETRIEVAL_HOUR:?"You need provide the image retrieval hour (HH format)"} 

# Generalizing parameters
INSTITUITION_NAME=noaa
echo "* Retrieving images from satellite '${NOAA_SATELLITE_NAME}' provided by '${INSTITUITION_NAME}'"

S3_BUCKET_NAME=${INSTITUITION_NAME}-${NOAA_SATELLITE_NAME}
S3_BUCKET_PATH="${NOAA_ABI_PRODUCT_NAME}/${IMAGE_RETRIEVAL_YEAR}/${IMAGE_RETRIEVAL_JULIAN_DAY}/${IMAGE_RETRIEVAL_HOUR}"
echo "* Images location: '${S3_BUCKET_NAME}/${S3_BUCKET_PATH}'"

# Entrypoint call
RETRIEVAL_CMD="aws s3 --no-sign-request ls --recursive ${S3_BUCKET_NAME}/${S3_BUCKET_PATH}" 
echo "=> Executing '${RETRIEVAL_CMD}'"

# https://stackoverflow.com/questions/19075671/how-do-i-use-shell-variables-in-an-awk-script/19075707#19075707 
bash -c "$RETRIEVAL_CMD" | awk -v bucket_name="$S3_BUCKET_NAME" '{print "https://"bucket_name".s3.amazonaws.com/"$4}'
