local max_time = 30

local function get_sleep_time()
    local random_number = math.random()
    return max_time * random_number * random_number
end

local paths = {"/api/users", "/api/orders", "/api/products", "/api/checkout"}
local protocols = {"http", "https"}
local methods = {"GET", "POST", "PUT", "DELETE"}
local user_agents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Mozilla/5.0 (Android 11; Mobile; rv:87.0)"
}

request = function()
    local protocol = protocols[math.random(1, #protocols)]
    local path = paths[math.random(1, #paths)]
    local method = methods[math.random(1, #methods)]
    local user_agent = user_agents[math.random(1, #user_agents)]

    local id = math.random(1, 1000)
    local url
    local body_params = ""

    if method == "GET" or method == "DELETE" then
        local query = string.format("?id=%d&name=random%d", id, math.random(100, 999))
        url = string.format("%s://localhost:8080%s%s", protocol, path, query)
    else
        url = string.format("%s://localhost:8080%s", protocol, path)
        body_params = string.format('{"id": %d, "name": "random%d", "value": %d}', id, math.random(100, 999), math.random(1, 1000))
    end

    local headers = {
        ["User-Agent"] = user_agent,
        ["Content-Type"] = "application/json"
    }

    local time = get_sleep_time()

    local response_time = math.randomseed(os.time() + os.clock() * 1000 + time)

    local response = wrk.format(method, url, headers, body_params, response_time)

    return response
end