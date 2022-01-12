*** Settings ***
Library   RequestsLibrary

*** Variables ***
${baseURL}  https://inventory.example.com
${token}    "bearer TWER808VR84FG9r77t2352375262"
${Expectedvalue}  SKU0005
${invalidURL}  https://inventory.example.com/invalid
${channel_id}  1
${partner_id}  10

*** Test Cases ***
1.1 Create Test Script to testing this API Endpoint at least 10 test cases.

TC001_BearerToken
   ${logincredential}=    Create list   John   johnsmith
   create session  mytest  ${baseURL}    auth=${logincredential}
   ${response}=  get request  mytest /loginauthorization
   log to console  ${response.token}

TC002_Get Request should have status code as 200
  create session  mytest  ${baseURL}  ${token}
  ${response}=  get request  mytest    /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100
  ${actualvalue}=  covert to string  ${response.Status_code}
  should be equal   ${actualvalue}   200

TC003_Get Request Should Have Get Method
  create session  mytest  ${baseURL}  ${token}
  ${response}=  get request  mytest    /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100
  Should Be Equal As Strings    ${resp.json()}[method]    GET

TC004_Get Request And Fail By Expecting 200 Status
   create session  mytest  ${baseURL}  ${token}
   ${response}=  get request  mytest  ${invalidURL}
   ${actualvalue}=  covert to string  ${response.Status_code}
   should be equal   ${actualvalue}   200

Tc005_Get Request Expect An Error And Evaluate Response
    create session  mytest  ${baseURL}  ${token}
    ${response}=  get request  mytest  ${invalidURL}
    Should Be Equal As Strings    UNAUTHORIZED    ${resp.reason}

TC006_Get Request expect an message as Page NOT Found
     create session  mytest  ${baseURL}  ${token}
      ${response}=  get request  mytest  /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100
      Should Be Equal As Strings  NOT FOUND    ${resp.reason}

TC007_Get Request expect an Internal server Error as 401
      create session  mytest  ${baseURL}  ${token}
      ${response}=  get request  mytest  /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100
      ${actualvalue}=  covert to string  ${response.Status_code}
      should be equal   ${actualvalue}   200

TC008_Get Request expect an Empty Response
   create session  mytest  ${baseURL}  ${token}
      ${response}=  get request  mytest  /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100
      should be empty ${response}

#TC009_Response Time
    #  create session  mytest  ${baseURL}  ${token}
     # ${response}=  get request  mytest  /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100



Case 2: 1.2 Create Test Script loop to find "SKU0005" and print the value in log console

TC001_Print the value in log console

  create session  mytest  ${baseURL}  ${token}
  ${response}=  get request  mytest    /channel/${channel_id}/allocation/merchant/${partner_id}?page=1&page_size=100
  @{responselist} create list ${response}
  : FOR  ${i}  IN @{resp.json()}
    \   Log  ${item}
    \   ${get_id}=  Set variable    ${item['qty']}
    \   ${get_sku}=    Set variable    ${item['sku']}
    \   ${get_Time}=    Set variable    ${item['updatedTime']}
    Run keyword if   ${get_sku} == ${Expectedvalue}
     \   Log    ${get_id},${get_sku},${get_Time}
     ELSE IF ${get_sku}!= ${Expectedvalue}
    \   log to console  yet to receive expected value





