########################################################################################################################
#!!
#! @input message: Message to send.
#! @input team: Mattermost team name.
#! @input channel: Mattermost channel name.
#!!#
########################################################################################################################
namespace: samples
flow:
  name: send_message
  inputs:
    - mattermost_url
    - username
    - password:
        sensitive: true
    - message
    - team
    - channel
  workflow:
    - get_session_token:
        do:
          authentication.get_session_token:
            - mattermost_url: '${mattermost_url}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_team_by_name
    - get_team_by_name:
        do:
          teams.get_team_by_name:
            - mattermost_url: '${mattermost_url}'
            - token: '${token}'
            - team_name: '${team}'
        publish:
          - team_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_public_channels
    - get_public_channels:
        do:
          channels.get_public_channels:
            - mattermost_url: '${mattermost_url}'
            - token:
                value: '${token}'
                sensitive: true
            - team_id: '${team_id}'
        publish:
          - channels
        navigate:
          - FAILURE: on_failure
          - SUCCESS: extract_channel_id
    - create_post:
        do:
          posts.create_post:
            - mattermost_url: '${mattermost_url}'
            - token:
                value: '${token}'
                sensitive: true
            - channel_id: '${channel_id}'
            - message: '${message}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - extract_channel_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${channels}'
            - json_path: "${\"$..[?(@.name=='\" + channel + \"')].id\"}"
        publish:
          - channel_id: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: create_post
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_session_token:
        x: 100
        y: 150
      get_team_by_name:
        x: 400
        y: 150
      get_public_channels:
        x: 700
        y: 150
      extract_channel_id:
        x: 1000
        y: 150
      create_post:
        x: 1300
        y: 150
        navigate:
          181e1d68-4b3b-726e-3dfc-447aa62ae343:
            targetId: b4ecb506-ec16-3369-b6e8-3fd567777053
            port: SUCCESS
    results:
      SUCCESS:
        b4ecb506-ec16-3369-b6e8-3fd567777053:
          x: 1600
          y: 150
