#/usr/bin/env sh

export CONTEXT_ROOT="${CONTEXT_ROOT%/}" # remove trailing slash
if [ -z "$CONTEXT_ROOT" ] ; then
    sed "/SCRIPT_NAME/d" -i /etc/nginx/templates/nginx.conf.template
    sed "/proxy_cookie_path/d" -i /etc/nginx/templates/nginx.conf.template
else
    export CONTEXT_ROOT="/${CONTEXT_ROOT#/}" # prepend slash if not present
fi
