namespace: authentication
flow:
  name: get_session_token
  inputs:
    - mattermost_url
    - username
    - password:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
  workflow:
    - get_token:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${mattermost_url + '/api/v4/users/login'}"
            - auth_type: anonymous
            - preemptive_auth: 'false'
            - headers: 'Content-Type:application/json, Accept:application/json'
            - body: "${'{\"login_id\":\"'+ username +'\",\"password\":\"'+ password +'\"}'}"
            - method: post
        publish:
          - token: "${(response_headers.split('MMAUTHTOKEN='))[1].split(';')[0]}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_token:
        x: 45
        y: 80
        navigate:
          32fc6521-38f6-874e-ea9a-33fff066d827:
            targetId: a06a359c-e042-cf07-c553-0b98d9eea3fa
            port: SUCCESS
    results:
      SUCCESS:
        a06a359c-e042-cf07-c553-0b98d9eea3fa:
          x: 279
          y: 83
