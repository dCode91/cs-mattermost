########################################################################################################################
#!!
#! @output channels: JSON object containing mattermost channels.
#!!#
########################################################################################################################
namespace: channels
flow:
  name: get_public_channels
  inputs:
    - mattermost_url
    - token:
        sensitive: true
    - team_id
  workflow:
    - get_public_channels:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${mattermost_url + '/api/v4/teams/' + team_id + '/channels'}"
            - auth_type: anonymous
            - preemptive_auth: 'false'
            - headers: "${'Authorization: Bearer ' + token}"
            - body: null
            - method: get
        publish:
          - channels: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - channels
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_public_channels:
        x: 65
        y: 100
        navigate:
          905a98ed-0924-19db-1df8-df7abba1da75:
            targetId: 466f581e-63ec-de8d-de0a-3c12d1b2fcaf
            port: SUCCESS
    results:
      SUCCESS:
        466f581e-63ec-de8d-de0a-3c12d1b2fcaf:
          x: 353
          y: 105
