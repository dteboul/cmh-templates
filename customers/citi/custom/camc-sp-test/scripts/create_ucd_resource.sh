#####################################################################
##
##      Created 1/16/19 by ucdpadmin. For Cloud cmh-azure
##
#####################################################################
while test $# -gt 0; do
  [[ $1 =~ ^-u|--user ]] && { PARAM_USER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-p|--password ]] && { PARAM_PASSWORD="${2}"; shift 2; continue; };
  [[ $1 =~ ^-h|--ucdhost ]] && { PARAM_UCDHOST="${2}"; shift 2; continue; };
  [[ $1 =~ ^-d|--resdesc ]] && { PARAM_RES_DESC="${2}"; shift 2; continue; };
  [[ $1 =~ ^-n|--resname ]] && { PARAM_RES_NAME="${2}"; shift 2; continue; };
  break;
done

json_var="{\"name\":\"${PARAM_RES_NAME}\",\"description\":\"${PARAM_RES_DESC}\", "
json_fixed="\"impersonationForce\":\"true\", \"impersonationUser\":\"root\"}"

json_ucd=${json_var}${json_fixed}

curlrespo=$(curl -k \
       -u ${PARAM_USER}:${PARAM_PASSWORD} \
       -X PUT "${PARAM_UCDHOST}/cli/resource/create" \
       -d "${json_ucd}"  2>/dev/null)

res_id=$(echo $curlrespo | jq '.id')
return_result="{\"resource_id\": ${res_id}, \"resource_name\": \"${PARAM_RES_NAME}\"}"

echo $return_result
