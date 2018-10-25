########################################################################################################################
#!!
#! @input channel_id: The channel ID to post in
#! @input message: The message contents, can be formatted with Markdown
#! @input root_id: The post ID to comment on
#!!#
########################################################################################################################
namespace: posts
flow:
  name: create_post
  inputs:
    - mattermost_url
    - token:
        sensitive: true
    - channel_id
    - message
    - root_id:
        required: false
  workflow:
    - create_a_post:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${mattermost_url + '/api/v4/posts'}"
            - auth_type: anonymous
            - preemptive_auth: 'false'
            - headers: "${'Authorization: Bearer ' + token}"
            - body: "${'{\"channel_id\": \"' + channel_id + '\", \"message\": \"' + message + '\", \"root_id\": \"' + get('root_id', '') + '\"}'}"
            - method: post
        publish:
          - channels: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_a_post:
        x: 85
        y: 120
        navigate:
          26510e94-34ff-8396-a587-5a1c86f99425:
            targetId: 06c74b97-0091-5339-90cb-d8eba7605ec2
            port: SUCCESS
    results:
      SUCCESS:
        06c74b97-0091-5339-90cb-d8eba7605ec2:
          x: 384
          y: 126
