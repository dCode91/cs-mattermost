namespace: teams
flow:
  name: get_team_by_name
  inputs:
    - mattermost_url
    - token
    - team_name
  workflow:
    - get_teams:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${mattermost_url + '/api/v4/teams/name/' + team_name}"
            - auth_type: anonymous
            - preemptive_auth: 'false'
            - headers: "${'Authorization: Bearer ' + token}"
            - body: null
            - method: get
        publish:
          - team_json: '${return_result}'
        navigate:
          - SUCCESS: get_id
          - FAILURE: on_failure
    - get_id:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${team_json}'
            - json_path: id
        publish:
          - team_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - team_id: '${team_id}'
    - team: '${team_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_teams:
        x: 45
        y: 80
      get_id:
        x: 208
        y: 82
        navigate:
          ceb660db-c18c-95b9-5172-5056c17289ea:
            targetId: dc4024fd-ea63-09db-eee5-0478f8c48266
            port: SUCCESS
    results:
      SUCCESS:
        dc4024fd-ea63-09db-eee5-0478f8c48266:
          x: 378
          y: 90
