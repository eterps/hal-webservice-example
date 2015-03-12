Feature: Artists

  Scenario: Get the API index
    When the client provides the header "Accept: application/hal+json"
    And the client does a GET request to "https://api.artistry.net"
    Then the response should be HAL JSON:
      """json
      {
        "_links": {
          "self": {
            "href": "https://api.artistry.net/"
          },
          "artist": {
            "href": "https://api.artistry.net/artist/{name}"
          },
          "artists": {
            "href": "https://api.artistry.net/artists"
          },
          "album": {
            "href": "https://api.moosicstore.com/album/{name}"
          }
        }
      }
      """

  Scenario: Get information about the artist Radiohead
    Given these albums:
      | artist    | album       |
      | Radiohead | Pablo Honey |
      | Radiohead | OK Computer |
    When the client provides the header "Accept: application/hal+json"
    And the client does a GET request to "https://api.artistry.net/artist/Radiohead"
    Then the response should be HAL JSON:
      """json
      {
        "_links": {
          "self": {
            "href": "https://api.artistry.net/artist/Radiohead"
          },
          "albums": [
            {
              "href": "https://api.moosicstore.com/album/Pablo%20Honey"
            },
            {
              "href": "https://api.moosicstore.com/album/OK%20Computer"
            }
          ]
        },
        "name": "Radiohead"
      }
      """

  Scenario: Add a new artist
    Given the client provides the header "Content-Type: application/json"
    When the client does a POST request to "https://api.artistry.net/artists" with the following data:
      """json
      {
        "name": "Led Zeppelin"
      }
      """
    Then the status code should be "201" (Created)
    And the Location header should be "https://api.artistry.net/artist/Led%20Zeppelin"
    And this artist should exist:
      | name         |
      | Led Zeppelin |

  Scenario: List all artists
    Given the client provides the header "Accept: application/hal+json"
    When the client does a GET request to "https://api.artistry.net/artists"
    Then the response should be HAL JSON:
      """json
      {
        "_links": {
          "self": {
            "href": "https://api.artistry.net/artists"
          },
          "artists": [
            {
              "href": "https://api.artistry.net/artist/Radiohead"
            },
            {
              "href": "https://api.artistry.net/artist/Led%20Zeppelin"
            }
          ]
        }
      }
      """
