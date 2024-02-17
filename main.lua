local socket=require("socket")
local new_car={
    car_ID=1, --cuz mp
    pos={x=0,y=0},
    vel={x=10,y=0},
    rot=0,
    rotvel=0,
    mass=1257,
    inertia=1,
    inertria_scale=1.769,   --stole this value from assetto corsa mod
    CG_height=0.75, -->meters
    wheels={
        ["FL"]={
            tyre_params=1,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=-0.85,y=-1.01712 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
        },
        ["FR"]={
            tyre_params=1,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=0.85,y=-1.01712 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
        },

        ["RL"]={
            tyre_params=2,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=-0.85,y=1.59088 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
        },

        ["RR"]={
            tyre_params=2,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=0.85,y=1.59088 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
        },
    },
    tyre_params={
        [1]={
            D = 1.3, -- Peak stiffness factor
            E = 0.8, -- Curvature factor
            lxal=1,
            lyka=1,

        },
        [2]={
            D = 1.3, -- Peak stiffness factor
            E = 0.8, -- Curvature factor
            lxal=1,
            lyka=1,

        }
    },
    LA={x=0,y=0,t=0},
    debug={
        Flong={
            ["FL"]={x=0,y=0},
            ["FR"]={x=0,y=0},
            ["RL"]={x=0,y=0},
            ["RR"]={x=0,y=0},
        },
        Flat={
            ["FL"]={x=0,y=0},
            ["FR"]={x=0,y=0},
            ["RL"]={x=0,y=0},
            ["RR"]={x=0,y=0},
        },
        gpos={
            ["FL"]={x=0,y=0},
            ["FR"]={x=0,y=0},
            ["RL"]={x=0,y=0},
            ["RR"]={x=0,y=0},
        }
    }

}

_G.cars={} 

_G.campos={x=0,y=0}
_G.camzoom=0.1
function math.fastatan2(y, x)
    if x == 0.0 then
        if y > 0.0 then
            return math.pi / 2
        elseif y < 0.0 then
            return -math.pi / 2
        else
            return 0.0
        end
    end

    local angle = math.atan(math.abs(y / x))

    if x < 0.0 then
        angle = math.pi - angle
    end

    if y < 0.0 then
        angle = -angle
    end

    return angle
end
function love.load()
    love.window.setMode(1000,500,{vsync=false,resizable=true,msaa=1})
    _G.cars[1]={} --> 1 is always this player
    for i,v in pairs(new_car) do
        _G.cars[1][i]=v
    end
    
    local iner=0
    for i,v in pairs(_G.cars[1].wheels)do
        print(i,v)
        local wdc=math.sqrt(v.x*v.x+v.y*v.y)
        iner=iner+_G.cars[1].mass*wdc*wdc
    end
    iner=iner*_G.cars[1].inertria_scale
    _G.cars[1].inertia=iner
end
local function normalize_angle(angle)
    angle = angle % (2 * math.pi)
    if angle > math.pi then
        angle = angle - 2 * math.pi
    end
    return angle
end
local sr=0
local function sign(x)
    return x > 0 and 1 or (x < 0 and -1 or 0)
end
local ldt=1
local avgldt=0.002
function love.update(dt)
    ldt=dt
    avgldt=((avgldt*99)+dt) /100
    --ldt=dt
    if love.keyboard.isDown("+") then
        _G.camzoom=_G.camzoom+(dt*_G.camzoom)
    end
    if love.keyboard.isDown("-") then
        _G.camzoom=_G.camzoom-(dt*_G.camzoom)
    end
    if love.keyboard.isDown("up") then
        _G.campos.y=_G.campos.y-dt*15
    end
    if love.keyboard.isDown("down") then
        _G.campos.y=_G.campos.y+dt*15
    end
    if love.keyboard.isDown("right") then
        _G.campos.x=_G.campos.x+dt*15
    end
    if love.keyboard.isDown("left") then
        _G.campos.x=_G.campos.x-dt*15
    end
    local mm=1
    if love.keyboard.isDown("lshift") then
        mm=0.5
    elseif love.keyboard.isDown("rshift") then
        mm=0.25
    else
        mm=1
    end
    local dd=false
    
    if love.keyboard.isDown("a") then
        _G.cars[1].wheels["FR"].rot=-1/math.max(1,(math.sqrt(_G.cars[1].vel.x*_G.cars[1].vel.x+_G.cars[1].vel.y*_G.cars[1].vel.y)*0.15))*mm
        _G.cars[1].wheels["FL"].rot=-1/math.max(1,(math.sqrt(_G.cars[1].vel.x*_G.cars[1].vel.x+_G.cars[1].vel.y*_G.cars[1].vel.y)*0.15))*mm
        --car.rotvel=-1
        dd=true
        --car.rot=car.rot-dt*2
    end
    if love.keyboard.isDown("d") then
        --car.rotvel=1
        _G.cars[1].wheels["FR"].rot=1/math.max(1,(math.sqrt(_G.cars[1].vel.x*_G.cars[1].vel.x+_G.cars[1].vel.y*_G.cars[1].vel.y)*0.15))*mm
        _G.cars[1].wheels["FL"].rot=1/math.max(1,(math.sqrt(_G.cars[1].vel.x*_G.cars[1].vel.x+_G.cars[1].vel.y*_G.cars[1].vel.y)*0.15))*mm
        dd=true
        --car.rot=car.rot+dt*2
    end
    if dd==false then
        _G.cars[1].wheels["FR"].rot=0
        _G.cars[1].wheels["FL"].rot=0
        --car.rotvel=0
    end
    local dddd=false
    if love.keyboard.isDown("w") then
        for i,v in pairs(_G.cars[1].wheels)do
            _G.cars[1].wheels[i].w=v.w+dt*30
        end
        dddd=true
    end
    if love.keyboard.isDown("s") then
        for i,v in pairs(_G.cars[1].wheels)do
            _G.cars[1].wheels[i].w=v.w-dt*30
        end
        dddd=true
    end
    if dddd==false then
       -- for i,v in pairs(car.wheelsw)do
            --car.wheelsw[i]=0
        --end
    end
    for car_ID,car in pairs(_G.cars)do
        _G.cars[car_ID].rotvel=car.rotvel+car.LA.t*0.5*dt
        _G.cars[car_ID].vel.x=car.vel.x+car.LA.x*0.5*dt
        _G.cars[car_ID].vel.y=car.vel.y+car.LA.y*0.5*dt
        _G.cars[car_ID].pos.x=car.pos.x+car.vel.x*0.5*dt
        _G.cars[car_ID].pos.y=car.pos.y+car.vel.y*0.5*dt
        _G.cars[car_ID].rot=car.rot+car.rotvel *0.5*dt

        if car.rot<-math.pi then
            car.rot=2*math.pi-car.rot--math.pi
        elseif car.rot>math.pi then
            car.rot=car.rot-2*math.pi-- -math.pi
        end
        
        local TFX=0
        local TFY=0
        local TTQ=0
        for i,wheel in pairs(car.wheels)do
            local tyre_params=_G.cars[car_ID].tyre_params[wheel.tyre_params]
            local wp={ x = (wheel.x * math.cos(car.rot)) - (wheel.y * math.sin(car.rot)), y = (wheel.x * math.sin(car.rot)) + (wheel.y * math.cos(car.rot)) }
            local wdc=math.sqrt(wheel.x*wheel.x+wheel.y*wheel.y)
            local linvel={--global
                x = (-(wp.y) * car.rotvel)+car.vel.x ,
                y = ((wp.x) * car.rotvel)+car.vel.y
            }
            local slip_angle = normalize_angle(math.fastatan2(linvel.x, -linvel.y) -car.rot -wheel.rot)
            local linvm=math.sqrt(linvel.x*linvel.x+linvel.y*linvel.y)
            local linvmn=linvel.x*math.sin(car.rot)-linvel.y*math.cos(car.rot)
            if linvmn==0 then linvmn=1e-16 end
            local slipRatio = (wheel.w * wheel.radius - linvmn) / linvmn
            local Fz=car.mass*0.25*-9.81
            local combined_slip = math.sqrt(slipRatio*slipRatio + slip_angle*slip_angle) or 1E-6
            local normalized_slipRatio = math.abs(slipRatio / combined_slip)
            local normalized_slip_angle = math.abs(slip_angle / combined_slip)
            local longF=Fz * tyre_params.D * math.sin(1.65*math.atan(10*slipRatio-tyre_params.E*(10*slipRatio-math.atan(10*slipRatio))))
            local latF=Fz * tyre_params.D * math.sin(1.3*math.atan(10*slip_angle-tyre_params.E*(10*slip_angle-math.atan(10*slip_angle))))
            longF=longF*normalized_slipRatio
            latF=latF*normalized_slip_angle
            --longF=longF*math.cos(slip_angle)
            longF=longF*(math.cos(slip_angle)/math.abs(math.cos(slip_angle))) 


            _G.cars[car_ID].debug.Flat[i]={ x = (latF * math.cos(car.rot+wheel.rot)), y = (latF * math.sin(car.rot+wheel.rot))}
            _G.cars[car_ID].debug.Flong[i]={ x = -(longF*math.sin(car.rot+wheel.rot)) , y = (longF*math.cos(car.rot+wheel.rot))}
            _G.cars[car_ID].debug.gpos[i].x=wp.x+car.pos.x
            _G.cars[car_ID].debug.gpos[i].y=wp.y+car.pos.y
            TFX=TFX+(latF * math.cos(car.rot+wheel.rot))-(longF*math.sin(car.rot+wheel.rot))
            TFY=TFY+(latF * math.sin(car.rot+wheel.rot))+(longF*math.cos(car.rot+wheel.rot))
            TTQ=TTQ-(latF*math.cos(wheel.rot)*wheel.y)+(latF*math.sin(wheel.rot)*wheel.x)
            TTQ=TTQ+(longF*math.cos(wheel.rot)*wheel.x)+(longF*math.sin(wheel.rot)*wheel.y)
            if dd==false and i=="FR" then
                --car.wheelsrots["FR"]=slip_angle*1
            elseif dd==false and i=="FL" then
                --car.wheelsrots["FL"]=slip_angle*1
            end
        end

        local TA=TTQ/car.inertia
        _G.cars[car_ID].rotvel=car.rotvel+TA*0.5*dt
        local A={x=TFX/car.mass,y=TFY/car.mass}
        _G.cars[car_ID].LA={x=A.x,y=A.y,t=TA}
        _G.cars[car_ID].vel.x=car.vel.x+A.x*0.5*dt
        _G.cars[car_ID].vel.y=car.vel.y+A.y*0.5*dt
        _G.cars[car_ID].pos.x=car.pos.x+car.vel.x*0.5*dt
        _G.cars[car_ID].pos.y=car.pos.y+car.vel.y*0.5*dt
        _G.cars[car_ID].rot=car.rot+car.rotvel *0.5*dt
    end
    _G.campos={x=_G.cars[1].pos.x,y=_G.cars[1].pos.y}
end
function love.draw()
    love.graphics.clear()
    local screenX,screenY=love.graphics.getWidth( ),love.graphics.getHeight( )
    local screenXH,screenYH=screenX*0.5,screenY*0.5

    --draw 
    -- [[
    for i=-_G.campos.x-(screenXH*math.max(math.floor(_G.camzoom+0.5),1)),-_G.campos.x+(screenXH*math.max(math.floor(_G.camzoom+0.5),1)),20 do
        for ii=-_G.campos.y-(screenYH*math.max(math.floor(_G.camzoom+0.5),1)),-_G.campos.y+(screenYH*math.max(math.floor(_G.camzoom+0.5),1)),20 do
            love.graphics.setColor(.1,.1,.1,1)
            local tl={(i)/_G.camzoom,      (ii)/_G.camzoom}
            local tr={(i+10)/_G.camzoom,   (ii)/_G.camzoom}
            local bl={(i)/_G.camzoom,      (ii+10)/_G.camzoom}
            local br={(i+10)/_G.camzoom,   (ii+10)/_G.camzoom}
            
            tl[1]=tl[1]+screenXH
            tl[2]=tl[2]+screenYH
            bl[1]=bl[1]+screenXH
            bl[2]=bl[2]+screenYH
            tr[1]=tr[1]+screenXH
            tr[2]=tr[2]+screenYH
            br[1]=br[1]+screenXH
            br[2]=br[2]+screenYH
            
            love.graphics.polygon("fill",tl[1],tl[2],tr[1],tr[2],br[1],br[2],bl[1],bl[2])
        end
    end
    --]]
    --dar car
    local corners={
        {x=-0.15,y=-0.25},
        {x=0.15,y=-0.25},
        {x=-0.15,y=0.25},
        {x=0.15,y=0.25},
    }
    for car_ID,car in pairs(_G.cars) do
        for i,wheel in pairs(car.wheels)do
            local ptl={
                x=(((corners[1].x*math.cos(car.rot)-corners[1].y*math.sin(car.rot+wheel.rot))+car.debug.gpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
                y=(((corners[1].x*math.sin(car.rot)+corners[1].y*math.cos(car.rot+wheel.rot))+car.debug.gpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
            }
            local ptr={
                x=(((corners[2].x*math.cos(car.rot)-corners[2].y*math.sin(car.rot+wheel.rot))+car.debug.gpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
                y=(((corners[2].x*math.sin(car.rot)+corners[2].y*math.cos(car.rot+wheel.rot))+car.debug.gpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
            }
            local pbl={
                x=(((corners[3].x*math.cos(car.rot)-corners[3].y*math.sin(car.rot+wheel.rot))+car.debug.gpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
                y=(((corners[3].x*math.sin(car.rot)+corners[3].y*math.cos(car.rot+wheel.rot))+car.debug.gpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
            }
            local pbr={
                x=(((corners[4].x*math.cos(car.rot)-corners[4].y*math.sin(car.rot+wheel.rot))+car.debug.gpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
                y=(((corners[4].x*math.sin(car.rot)+corners[4].y*math.cos(car.rot+wheel.rot))+car.debug.gpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
            }
            love.graphics.setLineWidth(2)
            love.graphics.setColor(1,1,1,1)
            love.graphics.polygon("line",ptl.x,ptl.y,ptr.x,ptr.y,pbr.x,pbr.y,pbl.x,pbl.y)
            love.graphics.setColor(0,1,0,1)
            
            love.graphics.line((car.debug.gpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.debug.gpos[i].y-_G.campos.y)/_G.camzoom+screenYH,((car.debug.Flong[i].x*0.001+car.debug.gpos[i].x)-_G.campos.x)/_G.camzoom+screenXH,((car.debug.Flong[i].y*0.001+car.debug.gpos[i].y)-_G.campos.y)/_G.camzoom+screenYH)
            love.graphics.setColor(0,0,1,1)
            love.graphics.line((car.debug.gpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.debug.gpos[i].y-_G.campos.y)/_G.camzoom+screenYH,((car.debug.Flat[i].x*0.001+car.debug.gpos[i].x)-_G.campos.x)/_G.camzoom+screenXH,((car.debug.Flat[i].y*0.001+car.debug.gpos[i].y)-_G.campos.y)/_G.camzoom+screenYH)
            love.graphics.setColor(1,0,1,0.5)
            love.graphics.setLineWidth(1)
            --love.graphics.line((car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom+screenYH,((car.wheelsw[i]*math.sin(car.rot)*1+car.wheelsgpos[i].x)-_G.campos.x)/_G.camzoom+screenXH,((car.wheelsw[i]*-math.cos(car.rot)*1+car.wheelsgpos[i].y)-_G.campos.y)/_G.camzoom+screenYH)
            love.graphics.setColor(1,1,1,1)
            --love.graphics.print("sl: "..tostring(math.floor(car.wsl[i]*100)/100),(car.debug.gpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.debug.gpos[i].y-_G.campos.y)/_G.camzoom+screenYH)
        end
    end
    local car=_G.cars[1]
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("UPS: "..math.floor((100/avgldt)/100+0.5),100,100)
    love.graphics.print("camzoom: "..math.floor((_G.camzoom*100)+0.5)/100,300,100)
    love.graphics.print("campos: "..math.floor((_G.campos.x*100)+0.5)/100 .. math.floor((_G.campos.y*100)+0.5)/100,300,400)
    love.graphics.print("vel_xy: "..car.vel.x.." "..car.vel.y,10,10)
    love.graphics.print("vel_m: "..(math.floor(math.sqrt(car.vel.x*car.vel.x+car.vel.y*car.vel.y)*1000+.5)/1000).."m/s",500,10)
    love.graphics.print("rotvel: "..tostring(math.floor(car.rotvel*10000)/10000).." rad/s",500,30)
    love.graphics.print("rot: "..tostring(math.floor(car.rot*10000)/10000),30,50)
    love.graphics.print("vel_glob_rot: "..math.floor(math.atan2(car.vel.x, car.vel.y)*10000)/10000,30,70)
    --love.graphics.print("w: "..math.floor(car.wheelsw["FR"]*10000)/10000,30,90)
    love.graphics.print("slipratio: "..tostring(math.floor(sr*10000)/10000),30,110)  

    local ta=math.sqrt(car.LA.x*car.LA.x+car.LA.y*car.LA.y)/9.81
    love.graphics.print("G's: "..tostring(math.floor(ta*10000)/10000) .." G",30,130) 
    love.graphics.setColor(0,0,1,1)
    love.graphics.line((car.pos.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y-_G.campos.y)/_G.camzoom+screenYH,(car.pos.x+car.vel.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y+car.vel.y-_G.campos.y)/_G.camzoom+screenYH)
    local carf={
        x=-math.sin(car.rot+math.pi),--math.sin(car.rot),
        y=math.cos(car.rot+math.pi)--+math.cos(car.rot)
}
    love.graphics.setColor(1,1,1,1)
    love.graphics.line((car.pos.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y-_G.campos.y)/_G.camzoom+screenYH,(car.pos.x+carf.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y+carf.y-_G.campos.y)/_G.camzoom+screenYH)


end

love.run= function()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	--if love.timer then love.timer.step() end
    love.timer.step()
	local dt = 0
    -- Main loop time.
	return function()
        local start=love.timer.getTime()

		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		--if love.timer then dt = love.timer.step() end
        --if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        --end

		-- Call update and draw
        local uc = coroutine.create(function()
             love.update(dt)
        end)
        coroutine.resume(uc)
        --if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        local dc = coroutine.create(function()
            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()
                love.graphics.clear(love.graphics.getBackgroundColor())
                love.draw()
                love.graphics.present()
            end
        end)
        coroutine.resume(dc)
        love.timer.sleep(0.002-(love.timer.getTime()-start))
        --print(lag)
		--if love.timer then love.timer.sleep(0.002) end
	end
    
end