*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com

*** Test Cases ***

Get All Posts
    ${response}=    GET    ${BASE_URL}/posts
    Should Be Equal As Integers    ${response.status_code}    200
    ${posts}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${posts}

    FOR    ${post}    IN    @{posts}
        Dictionary Should Contain Key    ${post}    id
        Dictionary Should Contain Key    ${post}    userId
        Dictionary Should Contain Key    ${post}    title
        Dictionary Should Contain Key    ${post}    body 
        Should Be True    isinstance($post["id"], int)
        Should Be True    isinstance($post["userId"], int)
        Should Be True    isinstance($post["title"], str)
        Should Be True    isinstance($post["body"], str)
    END

Get Post By ID
    ${response}=    GET    ${BASE_URL}/posts/1
    Should Be Equal As Integers    ${response.status_code}    200
    ${post}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${post}[id]    1
    Dictionary Should Contain Key    ${post}    userId
    Dictionary Should Contain Key    ${post}    title
    Dictionary Should Contain Key    ${post}    body

Create New Post
    ${payload}=    Create Dictionary
    ...    title=QA automation test
    ...    body=This is a test post
    ...    userId=${1}

    ${response}=    POST    ${BASE_URL}/posts    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201

    ${data}=    Set Variable    ${response.json()}
    Should Be Equal    ${data}[title]    QA automation test
    Should Be Equal    ${data}[body]    This is a test post
    Should Be Equal As Integers    ${data}[userId]    1
    Dictionary Should Contain Key    ${data}    id

Update Post
    ${payload}=    Create Dictionary
    ...    id=${1}
    ...    title=Updated QA post
    ...    body=Updated test body
    ...    userId=${1}

    ${response}=    PUT    ${BASE_URL}/posts/1    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200

    ${data}=    Set Variable    ${response.json()}
    Should Be Equal    ${data}[title]    Updated QA post
    Should Be Equal    ${data}[body]    Updated test body

Partially Update Post
    ${payload}=    Create Dictionary
    ...    title=Patched QA title

    ${response}=    PATCH    ${BASE_URL}/posts/1    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200

    ${data}=    Set Variable    ${response.json()}
    Should Be Equal    ${data}[title]    Patched QA title

Delete Post
    ${response}=    DELETE    ${BASE_URL}/posts/1
    Should Be Equal As Integers    ${response.status_code}    200

Invalid Post ID
    ${response}=    GET    ${BASE_URL}/posts/999999    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

Invalid Endpoint
    ${response}=    GET    ${BASE_URL}/invalidendpoint    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

Get Users
    ${response}=    GET    ${BASE_URL}/users
    Should Be Equal As Integers    ${response.status_code}    200
    ${users}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${users}

Get Comments By Post ID
    ${params}=    Create Dictionary    postId=1
    ${response}=    GET    ${BASE_URL}/comments    params=${params}
    Should Be Equal As Integers    ${response.status_code}    200
    ${comments}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${comments}

Missing Required Payload
    ${payload}=    Create Dictionary    title=Missing fields
    ${response}=    POST    ${BASE_URL}/posts    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${data}=    Set Variable    ${response.json()}
    Should Be Equal    ${data}[title]    Missing fields
    Dictionary Should Contain Key    ${data}    id
    Log    JSONPlaceholder accepts incomplete payloads and returns 201 although body and userId are required by the supplied API specification.

Unexpected Input
    ${payload}=    Create Dictionary
    ...    title=QA automation test
    ...    body=This is a test post
    ...    userId=${1}
    ...    unexpectedField=unexpectedValue
    ${response}=    POST    ${BASE_URL}/posts    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${data}=    Set Variable    ${response.json()}
    Should Be Equal    ${data}[unexpectedField]    unexpectedValue
    Dictionary Should Contain Key    ${data}    id
    Log    JSONPlaceholder accepts and echoes unexpected fields.
