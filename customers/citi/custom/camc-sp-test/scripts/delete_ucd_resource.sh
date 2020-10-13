#####################################################################
##
##      Created 1/16/19 by ucdpadmin. For Cloud cmh-azure
##
#####################################################################
while test $# -gt 0; do
  [[ $1 =~ ^-u|--user ]] && { PARAM_USER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-p|--password ]] && { PARAM_PASSWORD="${2}"; shift 2; continue; };
  [[ $1 =~ ^-h|--ucdhost ]] && { PARAM_UCDHOST="${2}"; shift 2; continue; };
  [[ $1 =~ ^-i|--resid ]] && { PARAM_RES_ID="${2}"; shift 2; continue; };
  break;
done

curlrespo=$(curl -k \
       -u ${PARAM_USER}:${PARAM_PASSWORD} \
       -X DELETE "${PARAM_UCDHOST}/cli/resource/deleteResource?resource=${PARAM_RES_ID}"  2>/dev/null)

echo "${curlrespo}"
