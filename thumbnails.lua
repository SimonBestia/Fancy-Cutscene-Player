local gCache = {}

-- call to pre-load cutscene thumbnails by ID
-- returns a table of textures, or nil if it failed
function load_thumbnail(name)
	local cached = gCache[name]
	if not cached then
		local status,result = pcall(CreateTexture,"Thumbnails/"..name.."Thumb.png")
		if status then
			local extra = 2
			cached = {result}
			while status do
				status,result = pcall(CreateTexture,"Thumbnails/"..name.."Thumb"..extra..".png")
				if status then
					cached[extra] = result
					extra = extra + 1
				end
			end
			gCache[name] = cached
		end
	end
	return cached
end

-- get a thumbnail texture by ID and index (starting at 1)
-- returns a texture if one exists, or nil if none is at that index
function get_thumbnail(name,index)
	local cached = load_thumbnail(name)
	if cached then
		if type(index) ~= "number" then
			error("expected thumbnail index",2)
		end
		return cached[index]
	end
end

-- get the thumbnail count given an ID
-- returns the amount of textures, or 0 if it failed to load
function get_thumbnail_count(name)
	local cached = load_thumbnail(name)
	if cached then
		return table.getn(cached)
	end
	return 0
end

-- draw the thumbnail given an ID and styling arguments
-- returns true if the thumbnail was loaded and drawn, or false otherwise
function draw_thumbnail(name, x, y, height, r, g, b, a, scroll)
    local texture
    if scroll then
        local count = get_thumbnail_count(name)
        if count ~= 0 then
            texture = get_thumbnail(name, 1 + math.mod(math.floor(GetTimer() / 2000), count))
        end
    else
        texture = get_thumbnail(name, 1)
    end
    if texture then
        local width = height * GetTextureDisplayAspectRatio(texture)
        DrawTexture(texture, x - width / 2, y - height / 2, width, height, r, g, b, a)
        return true
    end
    return false
end
