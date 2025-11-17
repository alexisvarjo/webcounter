*** Settings ***
Resource  resource.robot
Suite Setup  Open And Configure Browser
Suite Teardown  Close Browser

*** Test Cases ***
At start the counter is zero
    Go To  ${HOME_URL}
    Title Should Be  Laskuri
    Page Should Contain  nappia painettu 0 kertaa

When counter has a zero value and it is reset the value becomes zero
    Go To  ${HOME_URL}
    Click Button  Nollaa
    Page Should Contain  nappia painettu 0 kertaa

When counter has non-zero value it is reset the value becomes zero
    Go To  ${HOME_URL}
    Click Button  Paina
    Page Should Contain  nappia painettu 1 kertaa
    Click button  Nollaa
    Page Should Contain  nappia painettu 0 kertaa
