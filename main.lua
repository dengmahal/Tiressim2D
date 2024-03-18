---@diagnostic disable: lowercase-global
--local socket=require("socket")
package = package.path .. [[;..\]]
local debug = require("debug")
local ffi=require("ffi")
print(love.getVersion())

print(love.filesystem.getWorkingDirectory())
print(love.filesystem.getSource() )
local WindowsGamingInput  = ffi.load("Windows.Gaming.Input.dll")
--local SSteam= ffi.load([[C:\Users\nigri\Desktop\programmingstuff\Tiressim2D\luasteam.dll]])
local Steam = require("luasteam")
local discordRPC = require("discordRPC")

local TICK_RATE = 1 / 1000
--discord stuff
local appId_txt =  io.open(love.filesystem.getSource().."/../discord_id.txt","r")
---@diagnostic disable-next-line: need-check-nil
local appId=appId_txt:read("*a")
print(appId)

function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes") --damn
end
--
--165
local default_tyre_params={ --205/60R15 91V
        longitudinal_coefficients={
            p_Cx1=1.579,p_Dx1=1.0422,p_Dx2=-0.08285,p_Dx3=0,
            p_Ex1=0.11113,p_Ex2=0.3143,p_Ex3=0,p_Ex4=0.001719,
            p_Kx1=21.687,p_Kx2=13.728,p_Kx3=-0.4098,
            p_Hx1=2.1615e-4,p_Hx2=0.0011598,p_Vx1=2.0283e-5,p_Vx2=1.0568e-4,
            p_px1=-0.3485,p_px2=0.37824,p_px3=-0.09603,p_px4=0.06518,
            r_Bx1=13.046,r_Bx2=9.718,r_Bx3=0,r_Cx1=0.9995,r_Ex1=-0.4403,r_Ex2=-0.4663,r_Hx1=-9.968e-5
        },
        lateral_coefficients={
            p_Cy1=1.338,p_Dy1=0.8785,p_Dy2=-0.06452,p_Dy3=0,
            p_Ey1=-0.8057,p_Ey2=-0.6046,p_Ey3=0.09854,p_Ey4=-6.697,p_Ey5=0,
            p_Ky1=-15.324,p_Ky2=1.715,p_Ky3=0.3695,p_Ky4=2.0005,p_Ky5=0,p_Ky6=-0.8987,p_Ky7=-0.23303,
            p_Hy1=-0.001806,p_Hy2=0.00352,p_Vy1=-0.00661,p_Vy2=0.03592,p_Vy3=-0.162,p_Vy4=-0.4864,
            p_py1=-0.6255,p_py2=-0.06523,p_py3=-0.16666,p_py4=0.2811,p_py5=0,
            r_By1=10.622,r_By2=7.82,r_By3=0.002037,r_By4=0,r_Cy1=1.0587,
            r_Ey1=0.3148,r_Ey2=0.004867,r_Hy1=0.009472,r_Hy2=0.009754,
            r_Vy1=0.05187,r_Vy2=4.853e-4,r_Vy3=0,r_Vy4=94.63,r_Vy5=1.8914,r_Vy6=23.8
        },
        rolling_coefficients={
            q_sy1=0.00702,q_sy2=0,q_sy3=0.001515,q_sy4=8.514e-5,q_sy5=0,
            q_sy6=0,q_sy7=0.9008,q_sy8=-0.4089
        },
        aligning_coefficients={
            q_Bz1=12.035,q_Bz2=-1.33,q_Bz3=0,q_Bz4=0.176,q_Bz5=-0.14853,q_Bz9=34.5,q_Bz10=0,q_Bz6=0,
            q_Cz1=1.2923,q_Dz1=0.09068,q_Dz2=-0.00565,q_Dz3=0.3778,q_Dz4=0,q_Dz6=0.0017015,
            q_Dz7=-0.002091,q_Dz8=-0.1428,q_Dz9=0.00915,q_Dz10=0,q_Dz11=0,
            q_Ez1=-1.7924,q_Ez2=0.8975,q_Ez3=0,q_Ez4=0.2895,q_Ez5=-0.6786,
            q_Hz1=0.0014333,q_Hz2=0.0024087,q_Hz3=0.24973,q_Hz4=-0.21205,
            p_pz1=-0.4408,p_pz2=0,
            s_sz1=0.00918,s_sz2=0.03869,s_sz3=0,s_sz4=0
        },
        turnslip_coefficients={
            p_Dxfi1=0.4,p_Dxfi2=0,p_Dxfi3=0,
            p_Kyfi1=1,p_Dyfi1=0.4,p_Dyfi2=0,p_Dyfi3=0,p_Dyfi4=0,
            p_Hyfi1=1,p_Hyfi2=0.15,p_Hyfi3=0,p_Hyfi4=-4,
            p_Egfi1=0.5,p_Egfi2=0,
            q_Dtfi1=10,q_Crfi1=0.2,q_Crfi2=0.1,q_Brfi1=0.1,q_Drfi1=1,q_Drfi2=0
        },
        L_pure_slip={--longitudinal=x, lateral=y
            L_Fz0=3000,         --nominal (rated) load in NEWTON  => change this to about 1/9.80665 the expected load(kg), if this is too low shimmy may accur(not good, but realistic)
            L_mux=1,L_muy=1,    --peak friction coefficient
            L_Kxk=1,L_Kyk=1,    --brake slip stiffness
            L_Cx=1,L_Cy=1,      --shape factor
            L_Ex=1,L_Ey=1,      --curvature factor
            L_Hx=1,L_Hy=1,      --horizontal shift
            L_Vx=1,L_Vy=1,      --vertical shift
            L_Kya=1,            --cornering stiffness
            L_Kyg=1,            --camber force stiffness
            L_Kzg=1,            --camber torque stiffness
            L_t=1,              --pneumatic trail
            L_Mr=1,             --residual torque
        },
        L_combined_slip={
            L_xa=2,             --slip_angle influence on F_x
            L_yk=1,             --slip_ratio influence on F_y
            L_Vyk=1,            --slip_ratio induced ply-steer F_y
            L_smz=1,            --moment arm of F_x
        },
        L_other={
            L_Cz=1,             --radial tire stiffness
            L_mx=1,             --overturning couple stiffness
            L_VMx=1,            --overturning couple vertical shift
            L_My=0.5,             --rolling resistance moment
            J_y=0.8,            --reduction factor for camber (the closer the tire to a ball the closer to 0 this should be)
            J_x=0.8,            --reduction factor for camber (the closer the tire to a ball the closer to 0 this should be)
            L_Mfi=1,            --vanisching wheel speed-, constant turning moment
            p_i0=2220000,       --normal inflation presssure (pascals)
            V_0=16.67,          --reference velocity ->Velocity used when finding parameters
        },
        tremprature_coefficients={  --always check desmos graph to verify realistic values!
            T_1=-0.25,          --^2 effect on B (stiffness)
            T_2=0.5,            --^4 effect on B (stiffness)
            T_3=0.6,            --^2 effect on D (peak)
            T_4=0.15,           --^4 effect on D (peak)
            T_5=1,              --^2 asymetric effect on D (peak)  => T>T_ref       range <0.15
            T_6=0.1,            --^2 asymetric effect on D (peak)  => T<T_ref       range >-0.15
            T_ref=100,          --reference temperature
        },
        wet_coefficients={
            W_V=1.15567022142689,--aquaplaning effect on F_z (peak)
            W_E=0.030927835055,  --effect on E (curvature)
            W_D=0.149425287356,  --effect on D (peak)
            W_C=0.21052631579,   --effect on C (shape)
            W_B=0.2,             --effect on B (stiffness)
        }

    }


local new_car={
    car_ID=1, --cuz mp
    pos={x=0,y=0},
    vel={x=00,y=-10},
    rot=0,
    rotvel=0,
    mass=1257,
    cgear=1,
    inertia=1,      --will be calced automatacly
    inertria_scale=1.0769,
    CG_height=0.75, -->meters
    diffs={
        [1]={"RR","RL",1,350,1}      --powers1, powers2, lockrate(0=open diff, 1= welded diff) ,preload,final drive
    },
    steering_axles={{"FL","FR",math.rad(45),0.1}}, --wheelL, wheelR, max steering value, ackerman constant    ==> steering angle has no physical unit, and also dependant on wheelbase y and ackerman
    transmission_powers_diff=1,
    engine={
        idle_rpm=700,
        rev_limiter=6500,
        bounce_time=0.3,        --in seconds
        inertia=0.004,
        engine_braking=0.001,   --Nm/rpm
        tq_curve={--rpm, torque(Nm)             --non turbo!!!
            {-10e64,    0},    
            {0,         0},
            {1000,      60},
            {1500,      85},
            {2000,      105},
            {2500,      120},
            {3000,      130},
            {3250,      133},
            {3500,      133},
            {4000,      132},
            {4500,      130},
            {5000,      124},
            {5250,      120},
            {5500,      114},
            {6000,      100},
            {6500,      85},
            {7000,      60},
            {7500,      10},
            {8000,       0},
            {10e64,      0},
        },
        rpm=0,

    },
    transmission={
        gears={
            [-1]=-6,
            [1]=5,
            [2]=3.25,
            [3]=2.25,
            [4]=1.7,
            [5]=1.3,
        },
        loss=0.01       --transmission torque loss in %
    },
    drivetrain_inertia=0.001,    --inertia of drivetrain (transmission+driveline+differential)

    wheels={
        ["FL"]={
            tyre_params=1,      --id
            radius=0.31725,     --in meters
            x=-0.85,y=-1.01712 ,--->position relative to CG
            w=0,               --rad/s --> not a constant        
            rot=0,              --rad --> not a constant
            camber=math.rad(-5),--in rad
            tempratur=20,       --in K° --> not a constant (well for not it is)
            lr=0,               --auto
            inertia=0.3,         --kg*m^2
            wa=0,               --last wheel angular acceleration -> auto
        },
        ["FR"]={
            tyre_params=1,  --id
            radius=0.31725,
            x=0.85,y=-1.01712 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
            camber=math.rad(-5),
            tempratur=20,
            lr=0,
            inertia=0.3,
            wa=0,
        },

        ["RL"]={
            tyre_params=2,  --id
            radius=0.31725,
            x=-0.85,y=1.59088 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
            camber=math.rad(-5),
            tempratur=20,
            lr=0,
            inertia=0.3,
            wa=0,
        },

        ["RR"]={
            tyre_params=2,  --id
            radius=0.31725,
            x=0.85,y=1.59088 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
            camber=math.rad(-5),
            tempratur=20,
            lr=0,
            inertia=0.3,
            wa=0,
        },
    },
    tyre_params={
        [1]=default_tyre_params,
        [2]=default_tyre_params,
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
        },
        sr={
            ["FL"]=0,
            ["FR"]=0,
            ["RL"]=0,
            ["RR"]=0,
        },
        sa={
            ["FL"]=0,
            ["FR"]=0,
            ["RL"]=0,
            ["RR"]=0,
        },
        tq={
            ["FL"]=0,
            ["FR"]=0,
            ["RL"]=0,
            ["RR"]=0,
        }
    },
    wheelbasey=0,
}
new_car.tyre_params[1].L_pure_slip.L_muy=2
new_car.tyre_params[1].L_pure_slip.L_mux=2
new_car.tyre_params[2].L_pure_slip.L_mux=1
new_car.tyre_params[2].L_pure_slip.L_muy=1
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
local joysticks=love.joystick.getJoysticks()
function love.load(arg,unfilteredArg)
    joysticks=love.joystick.getJoysticks()
    for i,v in pairs(joysticks)do
        print(i,v:getAxes())
    end
    --Steam.init()
   -- love.window.setMode(1000,500,{vsync=true,resizable=true,msaa=1})
    --discordRPC.initialize(appId, true)
---@diagnostic disable-next-line: param-type-mismatch
    local now = os.time(os.date("*t"))
    presence = {
        state = "Driving",
        details = "nan",
        startTimestamp = now,
        endTimestamp = 0,
        partyId = "10",
        partyMax = 69420,
        matchSecret = "match secret",
        joinSecret = "join secret",
        spectateSecret = "spectate secret",
        largeImageKey ="iconnn",
        largeImageText ="game in dev",
    }

    nextPresenceUpdate = 0
    _G.cars[1]={} --> 1 is always this player
    for i,v in pairs(new_car) do
        _G.cars[1][i]=v
    end
    
    local iner=0
    local yfp=0
    local yfn=0
    for i,v in pairs(_G.cars[1].wheels)do
        print(i,v)
        local wdc=math.sqrt(v.x*v.x+v.y*v.y)
        iner=iner+_G.cars[1].mass*wdc*wdc
        if v.y>yfp then
            yfp=v.y
        end
        if v.y<yfn then
            yfn=v.y
        end
        --_G.cars[1].wheels[i].inertia=v.inertria_scale*(v.radius*v.radius+(v.radius-0.1)*(v.radius-0.1))*0.5*v.mass
        print(_G.cars[1].wheels[i].inertia.." kg*m^2")
        _G.cars[1].wheels[i].Lw=0
    end
    _G.cars[1].wheelbasey=math.abs(yfn-yfp)
    print(_G.cars[1].wheelbasey)
    iner=iner*_G.cars[1].inertria_scale
    _G.cars[1].inertia=iner
    _G.cars[1].transmission.forward_gears=0
    _G.cars[1].transmission.back_gears=0
    for i,v in pairs(_G.cars[1].transmission.gears)do
        if i>0 then
            _G.cars[1].transmission.forward_gears=_G.cars[1].transmission.forward_gears+1
        end
        if i<0 then
            _G.cars[1].transmission.back_gears=_G.cars[1].transmission.back_gears+1
        end
    end
    
    
    --local success = Steam.friends.setRichPresence('steam_display', "#StatusFull")
    --local success2 = Steam.friends.setRichPresence('status', "debbuging")
    --print(success,success2)
    
end

function love.quit()
    --Steam.shutdown()
    --discordRPC.shutdown()
end

local function normalize_angle(angle)
    angle = angle % (math.pi*2)
    if angle > math.pi then
        angle = angle - math.pi*2
    elseif angle < -math.pi then
        angle = angle + math.pi*2
    end
    return angle
end
local sr=0
---@diagnostic disable-next-line: duplicate-set-field
function math.sign(x)
    return x > 0 and 1 or (x < 0 and -1 or 0)
end
local ldt=1
local avgldt=TICK_RATE
local trot=0
print(math.sign(0))

local pressed_up=false
local pressed_down=false

function love.update(dt)
    --local success = Steam.friends.setRichPresence('debug', 'debugging2')
    --print(success)
 
    
   
    


    if nextPresenceUpdate < love.timer.getTime() then
        --"x"..tostring(cars[1].vel.x).." y"..tostring(cars[1].vel.y)
        presence.details="v = "..tostring(math.floor(math.sqrt(cars[1].vel.x*cars[1].vel.x+cars[1].vel.y*cars[1].vel.y)*1000)/1000).."m/s"
        presence.state="Driving ".."x"..tostring(math.floor(cars[1].vel.x*1000)/1000).." y"..tostring(math.floor(cars[1].vel.y*1000)/1000)
        --discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + 3
    end
    --discordRPC.runCallbacks()

    
    avgldt=((avgldt*99)+(love.timer.getTime()-ldt)) /100
    ldt=love.timer.getTime()
    local throttle=0.1
    local clutch=0
    local brake=0
    local steer=-0
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
    if love.keyboard.isDown("h") then
        _G.cars[1].pos={x=0,y=0,z=0}
    end
    local mm=1
    if love.keyboard.isDown("lshift") then
        clutch=0
    else
        clutch=1
    end
    if love.keyboard.isDown("r") then
        cars[1].rot=cars[1].rot+dt*5
    end
    local dd=false
    local did_steer=false
    if love.keyboard.isDown("a") then
        steer=-0.25 --1/math.sqrt(cars[1].vel.x*cars[1].vel.x+cars[1].vel.y*cars[1].vel.y)*mm
        did_steer=true
        
    end
    if love.keyboard.isDown("d") then
        steer=0.25 --1/math.sqrt(cars[1].vel.x*cars[1].vel.x+cars[1].vel.y*cars[1].vel.y)*mm
        did_steer=true
    end
    if did_steer==false then
        steer=0
    end
    if love.keyboard.isDown("w") then
        throttle=1
        if love.keyboard.isDown("f") then
            throttle=10
        end
    else
        throttle=0
    end
    if love.keyboard.isDown("q") then
        if pressed_down==false then
            pressed_down=true
            _G.cars[1].cgear=_G.cars[1].cgear-1
            if _G.cars[1].cgear<_G.cars[1].transmission.back_gears then
                _G.cars[1].cgear=-_G.cars[1].transmission.back_gears
            end
            if _G.cars[1].cgear==0 then _G.cars[1].cgear=-1 end
        end
    else
        pressed_down=false
    end
    if love.keyboard.isDown("e") then
        if pressed_up==false then
            pressed_up=true
            _G.cars[1].cgear=_G.cars[1].cgear+1
            if _G.cars[1].cgear>_G.cars[1].transmission.forward_gears then
                _G.cars[1].cgear=_G.cars[1].transmission.forward_gears
            end
            if _G.cars[1].cgear==0 then _G.cars[1].cgear=1 end
        
        end
    else
        pressed_up=false
    end

    if love.keyboard.isDown("s") then
        brake=1
        _G.cars[1].wheels["RR"].w=-3
        _G.cars[1].wheels["RL"].w=-3
        else
        brake=0
    end    
    --throttle=math.min((joysticks[1].getAxis(joysticks[1],6)+1)*0.5,1)
    --steer=math.min(joysticks[1].getAxis(joysticks[1],1),1)

    local wettness=0 --update this, its not a constant
    for car_ID,car in pairs(_G.cars)do
        _G.cars[car_ID].rotvel=car.rotvel+car.LA.t*0.5*dt
        _G.cars[car_ID].vel.x=car.vel.x+car.LA.x*0.5*dt
        _G.cars[car_ID].vel.y=car.vel.y+car.LA.y*0.5*dt
        _G.cars[car_ID].pos.x=car.pos.x+car.vel.x*0.5*dt
        _G.cars[car_ID].pos.y=car.pos.y+car.vel.y*0.5*dt
        _G.cars[car_ID].rot=car.rot+car.rotvel *0.5*dt
        -- [[
           -- print(steer)
        for _,steering_axle in pairs(car.steering_axles) do
            local leftwheelangle = 0
            local rightwheelangle = 0
            local ackermanconstant=steering_axle[4]*math.sign(steer) --sign fix
            local turnradius=1/math.tan(steer*steering_axle[3]) -- Radius of turn
            local innerangle=math.atan(car.wheelbasey/(turnradius+ackermanconstant))
            local outerangle=math.atan(car.wheelbasey/(turnradius-ackermanconstant))
            if steer >= 0 then
                leftwheelangle=innerangle
                rightwheelangle=outerangle
            else
                leftwheelangle=outerangle
                rightwheelangle=innerangle
            end
            car.wheels[steering_axle[1] ].rot=leftwheelangle
            car.wheels[steering_axle[2] ].rot=rightwheelangle
            --print(steer,leftwheelangle,rightwheelangle)
        end
        --]]
        local engine_toque=0
        for i,v in pairs(car.engine.tq_curve) do
            --print(i,v[1],v[2])
            if car.engine.rpm>=v[1] and car.engine.rpm<=car.engine.tq_curve[i+1][1] then
                engine_toque=v[2]+(((car.engine.rpm-v[1])/(car.engine.tq_curve[i+1][1]-v[1]))*(car.engine.tq_curve[i+1][2]-v[2]))
                engine_toque=engine_toque*throttle
                break
            end 
        end
        local trans_torque=0
        if car.cgear==0 then
            trans_torque=0
        else
            trans_torque=engine_toque*car.transmission.gears[car.cgear]
            local engine_rads=((car.wheels[car.diffs[1][1]].w+car.wheels[car.diffs[1][1]].w)*0.5)*(car.diffs[1][5]*car.transmission.gears[car.cgear])/car.wheels["FR"].radius
            _G.cars[car_ID].engine.rpm=math.max(math.min(60*engine_rads/(2*math.pi),50000),-5000)
        end
        ---still needs clutch sim!! avgtq&avgrpm & clutch
        
        
        
        --local trans_torque=throttle*6000
        if car.rot<-math.pi then
            car.rot=2*math.pi-car.rot--math.pi
        elseif car.rot>math.pi then
            car.rot=car.rot-2*math.pi-- -math.pi
        end
        
        local TFX=0
        local TFY=0
        local TTQ=0
        --lat=F_y
        --long=F_x
        --
        for i,wheel in pairs(car.wheels)do
            
            _G.cars[car_ID].wheels[i].w=_G.cars[car_ID].wheels[i].w+ wheel.Lw*dt*0.5
            --_G.cars[car_ID].wheels[i].w=math.min(_G.cars[car_ID].wheels[i].w,200)
            --local tyre_params=_G.cars[car_ID].tyre_params[wheel.tyre_params]
            local tp=default_tyre_params
            local tp_lo=tp.longitudinal_coefficients
            local tp_la=tp.lateral_coefficients
            local tp_ro=tp.rolling_coefficients
            local tp_al=tp.aligning_coefficients
            local tp_ts=tp.turnslip_coefficients
            local tp_Lp=tp.L_pure_slip
            local tp_Lc=tp.L_combined_slip
            local tp_Lo=tp.L_other
            local tp_we=tp.wet_coefficients
            local tp_te=tp.tremprature_coefficients
            local wp={ x = (wheel.x * math.cos(car.rot)) - (wheel.y * math.sin(car.rot)), y = (wheel.x * math.sin(car.rot)) + (wheel.y * math.cos(car.rot)) }
            local wdc=math.sqrt(wheel.x*wheel.x+wheel.y*wheel.y)
            local linvel={--global
                x = (-(wp.y) * car.rotvel)+car.vel.x ,
                y = ((wp.x) * car.rotvel)+car.vel.y
            }
            local slip_angle = -normalize_angle(math.fastatan2(linvel.x, -linvel.y) -car.rot -wheel.rot)
            local linvm=math.sqrt(linvel.x*linvel.x+linvel.y*linvel.y)
            local linvmn=linvel.x*math.sin(car.rot)-linvel.y*math.cos(car.rot)
            if linvmn==0 then linvmn=1e-16 end
            local V_x=linvmn
            local V_sx=V_x-wheel.w*wheel.radius    	
            local V_r=wheel.w*wheel.radius
            local V_cx=V_r+V_sx           													-->wheel slip velocity of slip point S
            local slipRatio=-V_sx/math.abs(V_x)
            --local slipRatio = (wheel.w * wheel.radius - linvmn) / linvmn
            --local slipRatio=(wheel.w*wheel.radius/linvm)
            --print(slipRatio)
            car.debug.sr[i]=slipRatio
            car.debug.sa[i]=slip_angle
            

            
            local pi=tp_Lo.p_i0
            local p_di=(pi-tp_Lo.p_i0)/tp_Lo.p_i0
            local Fz=car.mass*0.25*9.80665
            local fz=0
            --tempratur
            local T_d=(wheel.tempratur-tp_te.T_ref)/tp_te.T_ref
            local T_d2=T_d*T_d
            local T_d4=T_d2*T_d2
            local BTM=(1+tp_te.T_1*T_d2+tp_te.T_2*T_d4)
            local abstd5=math.abs(T_d)+T_d
            local abstd6=-math.abs(T_d)+T_d
            local DTD=1+tp_te.T_3*T_d2+tp_te.T_4*T_d4+abstd5*abstd5*tp_te.T_5-abstd6*abstd6*tp_te.T_6
            local DTW=(1+tp_we.W_D*wettness*wettness)
            local BTW=tp_we.W_B*wettness
            local CTW=tp_we.W_C*wettness
            local ETW=tp_we.W_E*wettness
            local fzdz0=Fz/tp_Lp.L_Fz0
            --#magic formula
            
            local Y=wheel.camber*math.sign(wheel.x)
            local YS=math.sin(Y)
            local aS=math.tan(slip_angle)*math.sign(V_cx)
            --turn slip
            wheel.wheelrate=0

            local fi_t=car.rotvel+wheel.wheelrate     -- -1/R
            local J_Y=tp_ts.p_Egfi1*(1+tp_ts.p_Egfi2*fz)
            local fi=-(1/linvm)*(car.rotvel-(1-J_Y)*wheel.w*YS)
            local absfi=math.abs(fi)
            local B_yfi=tp_ts.p_Dyfi1*(1+tp_ts.p_Dxfi2*fz)*math.cos(math.atan(tp_ts.p_Dxfi3*math.tan(slip_angle)))
            local Z3=math.cos(math.atan(tp_ts.p_Kyfi1*wheel.radius*wheel.radius*fi*fi))
            local C_Hyfi=tp_ts.p_Hyfi1
            local D_Hyfi=(tp_ts.p_Hyfi2+tp_ts.p_Hyfi3*fz)*math.sign(V_cx)
            local E_Hyfi=tp_ts.p_Hyfi4

            local Z2=math.cos(math.atan(B_yfi*(wheel.radius*absfi+tp_ts.p_Dyfi4*math.sqrt(wheel.radius*absfi))))

            local S_VyY=Fz*(tp_la.p_Vy3+tp_la.p_Vy4*fz)*YS*Z2*tp_Lp.L_Kyg*tp_Lp.L_muy
            --S_VyY=S_VyY*math.sign(wheel.x)
            local Z5=math.cos(math.atan(tp_ts.q_Drfi1*wheel.radius*fi))
            local C_Drfi=tp_ts.q_Drfi1
            local E_Drfi=tp_ts.q_Drfi2
            
            local J_r=10e-10
            local K_zYro=Fz*wheel.radius*(tp_al.q_Dz8+tp_al.q_Dz9*fz+(tp_al.q_Dz10+tp_al.q_Dz11*fz)*math.abs(Y))*tp_Lp.L_Kzg

            local Z6=math.cos(math.atan(tp_ts.q_Brfi1*wheel.radius*fi))
            
            local B_xfi=tp_ts.p_Dxfi1*(1+tp_ts.p_Dxfi2*fz)*math.cos(math.atan(tp_ts.p_Dxfi3*slipRatio))
            local Z1=math.cos(math.atan(B_xfi*wheel.radius*fi))
            local Z0=0
            --long_pure
            local S_Vx=Fz*(tp_lo.p_Vx1+tp_lo.p_Vx2)*tp_Lp.L_Vx*tp_Lp.L_mux*Z1
            local S_Hx=(tp_lo.p_Hx1+tp_lo.p_Hx2*fz)*tp_Lp.L_Hx
            local K_x=slipRatio+S_Hx
            local K_xk=Fz*(tp_lo.p_Kx1+tp_lo.p_Kx2*fz)*math.exp(tp_lo.p_Kx3*fz)*(1+tp_lo.p_px1*p_di+tp_lo.p_px2*p_di*p_di)*tp_Lp.L_Kxk
            local m_x=(tp_lo.p_Dx1+tp_lo.p_Dx2*fz*fz)*(1+tp_lo.p_px3*p_di*p_di)*(1+tp_lo.p_Dx3*Y*Y)*tp_Lp.L_mux
            local D_x=m_x*Fz*Z1
            local E_x=(tp_lo.p_Ex1+tp_lo.p_Ex2*fz+tp_lo.p_Ex3*fz*fz)*(1-tp_lo.p_Ex4*math.sign(K_x))*tp_Lp.L_Ex
            local C_x=tp_lo.p_Cx1*tp_Lp.L_Cx
            local B_x=K_xk/(C_x*D_x+tp_Lo.J_x)
            local B_xt=B_x*BTM
            local D_xt=D_x/DTD
            local E_xw=E_x-E_x*ETW
            local D_xtw=D_xt/DTW
            local C_xw=C_x+C_x*CTW
            local B_xtw=B_xt+B_xt*BTW
            local F_x0=D_xtw*math.sin(C_xw*math.atan(B_xtw*K_x-E_xw*(B_xtw*K_x-math.atan(B_xtw*K_x))))+S_Vx
            
            --lat_pure
            local K_yY0=Fz*(tp_la.p_Ky6+tp_la.p_Ky7*fz)*(1+tp_la.p_py5*p_di)*tp_Lp.L_Kyg
            local S_Vy=Fz*(tp_la.p_Vy1+tp_la.p_Vy2*fz)*tp_Lp.L_Vy*tp_Lp.L_muy*Z2+S_VyY*math.sign(wheel.x)
            local K_ya=tp_la.p_Ky1*tp_Lp.L_Fz0*(1+tp_la.p_Ky1*p_di)*(1-tp_la.p_Ky3*math.abs(YS))*math.sin(tp_la.p_Ky4*math.atan((Fz/tp_Lp.L_Fz0)/((tp_la.p_Ky2+tp_la.p_Ky5*YS*YS)*(1+tp_la.p_py2*p_di))))
            --
            local D_t0=Fz*(wheel.radius/tp_Lp.L_Fz0)*(tp_al.q_Dz1+tp_al.q_Dz2*fz)*(1-tp_al.p_pz1*p_di)*tp_Lp.L_t*math.sign(V_cx) 
            --
            local K_zYo=K_zYro-D_t0*K_yY0
            local K_zRfio=K_zYo/(1-J_Y)     --moment of stiffness against spin
            local K_yRfio=K_yY0/(1-J_Y)
            local B_Hyfi=K_yRfio/(C_Hyfi*D_Hyfi*K_ya)
            local S_Hyfi=D_Hyfi*math.sin(C_Hyfi*math.atan(B_Hyfi*wheel.radius*fi-E_Hyfi*(B_Hyfi*wheel.radius*fi-math.atan(B_Hyfi*wheel.radius*fi))))*math.sign(V_x)
            local S_Hy=(tp_la.p_Hy1+tp_la.p_Hy2*fz)*tp_Lp.L_Hy+S_Hyfi-(S_VyY/K_ya)
            local Z4=1+S_Hyfi-(S_VyY/K_ya)
            --
            local a_y=aS+S_Hy
            local E_y=(tp_la.p_Ey1+tp_la.p_Ey2*fz)*(1+tp_la.p_Ey5*YS*YS-(tp_la.p_Ey3+tp_la.p_Ey4*YS)*math.sign(a_y))*tp_Lp.L_Ey
            local m_y=(tp_la.p_Dy1+tp_la.p_Dy2+fz)*(1+tp_la.p_py3*p_di*p_di)*(1-tp_la.p_Dy3*YS*YS)*tp_Lp.L_muy
            --
            local M_zfii=tp_ts.q_Crfi1*m_y*wheel.radius*Fz*math.sqrt(Fz/tp_Lp.L_Fz0)*tp_Lo.L_Mfi
            local D_Drfi=M_zfii/math.sin(0.5*math.pi*C_Drfi)
            local B_Drfi=K_zYro/(C_Drfi*D_Drfi*(1-J_Y)+J_r)
            local D_rfi=D_Drfi*math.sin(C_Drfi-math.atan(B_Drfi*wheel.radius*fi-E_Drfi*(B_Drfi*wheel.radius*fi-math.atan(B_Drfi*wheel.radius*fi))))
            local Z8=1+D_rfi
            --
            local D_y=m_y*Fz*Z2
            local C_y=tp_la.p_Cy1*tp_Lp.L_Cy
            local D_yt=D_y/DTD
            local B_y=K_ya/(C_y*D_y+tp_Lo.J_y)
            local B_yt=B_y*BTM
            local D_ytw=D_yt/DTW
            local C_yw=C_y+C_y*CTW
            local B_ytw=B_yt+B_yt*BTW
            local E_yw=E_y+E_y*ETW
            local F_y0=D_ytw*math.sin(C_yw*math.atan(B_ytw*a_y-E_yw*(B_ytw*a_y-math.atan(B_ytw*a_y))))+S_Vy*math.sign(wheel.x) --*math.sign(wheel.x)= fix cuz tires are on 2 sides of car yk
            
            
            --long_combined
            local S_Hxa=tp_lo.r_Hx1
            local E_xa=tp_lo.r_Ex1+tp_lo.r_Ex2*fz
            local C_xa=tp_lo.r_Cx1
            local B_xa=(tp_lo.r_Bx1+tp_lo.r_Bx2*YS*YS)*math.cos(math.atan(tp_lo.r_Bx2*slipRatio))*tp_Lc.L_xa
            local a_s=aS+S_Hxa
            local G_xa0=math.cos(C_xa*math.atan(B_xa*S_Hxa-E_xa*(B_xa*S_Hxa-math.atan(B_xa*S_Hxa))))
            local G_xa=(math.cos(C_xa*math.atan(B_xa*a_s-E_xa*(B_xa*a_s-math.atan(B_xa*a_s)))))/G_xa0
            local F_x=G_xa*F_x0

            --lat_combined
            local D_Vyk=m_y*Fz*(tp_la.r_Vy1+tp_la.r_Vy2*fz+tp_la.r_Vy3*YS)*math.cos(math.atan(tp_la.r_Vy4*aS))*Z2
            local S_Vyk=D_Vyk*math.sin(tp_la.r_Vy5*math.atan(tp_la.r_Vy6*slipRatio))*tp_Lc.L_Vyk
            local S_Hyk=tp_la.r_Hy1+tp_la.r_Hy2*fz
            local E_yk=tp_la.r_Ey1+tp_la.r_Ey2*fz
            local C_yk=tp_la.r_Cy1
            local B_yk=(tp_la.r_By1+tp_la.r_By4*YS*YS)*math.cos(math.atan(tp_la.r_By2*(aS-tp_la.r_By3)))*tp_Lc.L_yk
            local k_s=slipRatio+S_Hyk
            local G_yk0=math.cos(C_yk*math.atan(B_yk*S_Hyk-E_yk*(B_yk*S_Hyk-math.atan(B_yk*S_Hyk))))
            local G_yk=math.cos(C_yk*math.atan(B_yk*k_s-E_yk*(B_yk*k_s-math.atan(B_yk*k_s))))/G_yk0
            local F_y=G_yk*F_y0+S_Vyk*math.sign(wheel.x)

            local M_zfi90=M_zfii*(2/math.pi)*math.atan(tp_ts.q_Crfi2*wheel.radius*math.abs(fi_t))*G_yk
            local Z7=(2/math.pi)*math.acos(M_zfi90/(math.abs(D_rfi)+J_r))

            --aligning torque pure --wait this isnt used? no it is :(
            local C_r=Z7
            local C_t=tp_al.q_Cz1                                                                                                                                                                                           
            local D_r=Fz*wheel.radius*((tp_al.q_Dz6+tp_al.q_Dz7*fz)*tp_Lp.L_Mr*Z2+((tp_al.q_Dz8+tp_al.q_Dz9*fz)*(1+tp_al.p_pz1*p_di)+(tp_al.q_Dz10+tp_al.q_Dz11*fz)*math.abs(YS))*YS*tp_Lp.L_Kzg*Z0)*tp_Lp.L_muy*math.sign(V_cx)*-math.sin(slip_angle)+Z8-1
            local B_r=(tp_al.q_Bz9*(tp_Lp.L_Kya/tp_Lp.L_muy)+tp_al.q_Bz10*B_y*C_y)
            local S_Ht=tp_al.q_Hz1+tp_al.q_Hz2*fz+(tp_al.q_Hz3+tp_al.q_Hz4*fz)*YS
            local a_t=aS+S_Ht
            local B_t=(tp_al.q_Bz1+tp_al.q_Bz2*fz*fz)*(1+tp_al.q_Bz5*math.abs(YS)+tp_al.q_Bz6*YS*YS)*(tp_Lp.L_Kya/tp_Lp.L_muy)
            local E_t=(tp_al.q_Ez1+tp_al.q_Ez2*fz+tp_al.q_Ez3*fz*fz)*(1+(tp_al.q_Ez4+tp_al.q_Ez5*YS)*(2/math.pi)*math.atan(B_t*C_t*a_t))

            local D_t=D_t0*(1+tp_al.q_Dz3*math.abs(YS)+tp_al.q_Dz4*YS*YS)*Z5
            local K_zao=D_t0*K_ya
            local K_sya=K_ya+1E-12 --J_K
            local S_Hf=S_Hy+(S_Vy/K_sya)
            local a_r=aS+S_Hf
            local M_zro=D_r*math.cos(C_r*math.atan(B_r*a_r))*-math.sin(slip_angle)
            local t0=D_t*math.cos(C_t*math.atan(B_t*a_t-E_t*(B_t*a_t-math.atan(B_t*a_t))))*-math.sin(slip_angle)
            local M_szo=-t0*F_y0
            local M_z0=M_szo+M_zro

            --aligning combined
            local KxkdKsya=K_xk/K_sya
            local KxkdKsyas=KxkdKsya*KxkdKsya
            local srsr=slipRatio*slipRatio
            local a_req=math.sqrt(a_r*a_r+KxkdKsyas*srsr)*math.sign(a_r)
            local a_teq=math.sqrt(a_t*a_t+KxkdKsyas*srsr)*math.sign(a_t)
            local s=wheel.radius*(tp_al.s_sz1+tp_al.s_sz2*(F_y/tp_Lp.L_Fz0)+(tp_al.s_sz3+tp_al.s_sz4*fz)*YS)*tp_Lc.L_smz
            local M_zr=D_r*math.cos(C_r*math.atan(B_r*a_req))*-math.sin(slip_angle)
            local F_sy=G_yk*F_y0
            local t=D_t*math.cos(C_t*math.atan(B_t*a_teq-E_t*(B_t*a_teq-math.atan(B_t*a_teq))))*-math.sin(slip_angle)
            local M_sz=-t*F_sy
            local M_z=M_sz+M_zr+s*F_x

            --rolling resistance moment
            local vxdv0=(V_x/tp_Lo.V_0)
            local M_y=Fz*wheel.radius*(tp_ro.q_sy1+tp_ro.q_sy2*(F_x/tp_Lp.L_Fz0)+tp_ro.q_sy3*math.abs(vxdv0)+tp_ro.q_sy4*vxdv0*vxdv0*vxdv0*vxdv0+(tp_ro.q_sy5+tp_ro.q_sy6*fzdz0)*Y*Y)*((fzdz0^tp_ro.q_sy7) *((pi/tp_Lo.p_i0)^tp_ro.q_sy8))*tp_Lo.L_My
            --print(M_y,fzdz0)
            --
            --[[old code below commented
            local combined_slip = math.sqrt(slipRatio*slipRatio + slip_angle*slip_angle) or 1E-6
            local normalized_slipRatio = math.abs(slipRatio / combined_slip)
            local normalized_slip_angle = math.abs(slip_angle / combined_slip)
            local longF=Fz * tyre_params.D * math.sin(1.65*math.atan(10*slipRatio-tyre_params.E*(10*slipRatio-math.atan(10*slipRatio))))
            local latF=Fz * tyre_params.D * math.sin(1.3*math.atan(10*slip_angle-tyre_params.E*(10*slip_angle-math.atan(10*slip_angle))))
            longF=longF*normalized_slipRatio*tyre_params.lxal
            latF=latF*normalized_slip_angle*tyre_params.lyka
            --longF=longF*math.cos(slip_angle)
            longF=longF*(math.cos(slip_angle)/math.abs(math.cos(slip_angle))) 
            --]]

            --F_x=math.abs(F_x)*(math.cos(slip_angle)/math.abs(math.cos(slip_angle)))
            --F_x=math.abs(F_x)*math.sign(slipRatio)
            --F_y=math.abs(F_y)*math.sign(slip_angle)
            F_x=-F_x
            F_y=-F_y
            _G.cars[car_ID].debug.Flat[i]={ x = (F_y * math.cos(car.rot+wheel.rot)), y = (F_y * math.sin(car.rot+wheel.rot))}
            _G.cars[car_ID].debug.Flong[i]={ x = -(F_x*math.sin(car.rot+wheel.rot)) , y = (F_x*math.cos(car.rot+wheel.rot))}
            _G.cars[car_ID].debug.gpos[i].x=wp.x+car.pos.x
            _G.cars[car_ID].debug.gpos[i].y=wp.y+car.pos.y
            TFX=TFX+(F_y * math.cos(car.rot+wheel.rot))-(F_x*math.sin(car.rot+wheel.rot))
            TFY=TFY+(F_y * math.sin(car.rot+wheel.rot))+(F_x*math.cos(car.rot+wheel.rot))
            TTQ=TTQ-(F_y*math.cos(wheel.rot)*wheel.y)+(F_y*math.sin(wheel.rot)*wheel.x)
            TTQ=TTQ+(F_x*math.cos(wheel.rot)*wheel.x)+(F_x*math.sin(wheel.rot)*wheel.y)
            if dd==false and i=="FR" then
                --car.wheelsrots["FR"]=slip_angle*1
            elseif dd==false and i=="FL" then
                --car.wheelsrots["FL"]=slip_angle*1
            end
            local diffbias=0.5 --needs fix
            
            local wa=(F_x*wheel.radius-M_y)/(wheel.inertia+car.engine.inertia*clutch+car.drivetrain_inertia*diffbias)
            _G.cars[car_ID].wheels[i].w=_G.cars[car_ID].wheels[i].w+ wa*dt*0.5
            _G.cars[car_ID].wheels[i].Lw=wa
            
        end
        for idiff,diff in pairs(car.diffs) do
            local TBR=0
            local WL=car.wheels[diff[1]]
            local WR=car.wheels[diff[2]]
            local RF=car.wheels[diff[1]].w
            local LF=car.wheels[diff[2]].w
            if LF>=RF then
                TBR=(LF/RF)
            else
                TBR=(RF/LF)
            end
            local tda=tonumber(TBR)-diff[4]


            local output_torque_left=(trans_torque)*0.5 +tda*math.sign(RF-LF)*diff[3]/diff[5]
            local output_torque_right=(trans_torque)*0.5 +tda*math.sign(LF-RF)*diff[3]/diff[5]
            local didnan=false
            if output_torque_left ~= output_torque_left  then
                output_torque_left=1
                didnan=true
            end
            if output_torque_right ~= output_torque_right  then
                output_torque_right=1
                didnan=true

            end
            _G.cars[car_ID].debug.tq[diff[1]]=output_torque_right
            _G.cars[car_ID].debug.tq[diff[2]]=output_torque_left
            local wal=(output_torque_left*WL.radius)/(WL.inertia+car.engine.inertia*clutch*(output_torque_left/output_torque_right*0.5)+car.drivetrain_inertia*(output_torque_left/output_torque_right*0.5)) 
            local war=(output_torque_right*WR.radius)/(WR.inertia+car.engine.inertia*clutch*(output_torque_right/output_torque_left*0.5)+car.drivetrain_inertia*(output_torque_right/output_torque_left*0.5))
            --if didnan==true then
            --    wal=(output_torque_left*WL.radius)/(WL.inertia+car.engine.inertia*clutch+car.drivetrain_inertia*0.5) 
            --    war=(output_torque_right*WR.radius)/(WR.inertia+car.engine.inertia*clutch+car.drivetrain_inertia*0.5)
            --end
            --print(output_torque_left,output_torque_right,WL.radius,WL.inertia,car.engine.inertia,clutch,car.drivetrain_inertia,war,wal,wal*dt*0.5,war*dt*0.5*0)
            
            if war~=war then
                war=0
            end
            if wal~=wal then
                wal=0
            end
            _G.cars[car_ID].wheels[diff[1]].w=_G.cars[car_ID].wheels[diff[1]].w +wal*dt*0.5
            _G.cars[car_ID].wheels[diff[2]].w=_G.cars[car_ID].wheels[diff[2]].w +war*dt*0.5
            _G.cars[car_ID].wheels[diff[1]].Lw=_G.cars[car_ID].wheels[diff[1]].Lw+wal
            _G.cars[car_ID].wheels[diff[2]].Lw=_G.cars[car_ID].wheels[diff[2]].Lw+war
            --print(wal,war,output_torque_left,output_torque_right)

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
function love.draw(dt)
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
            local tx=(car.debug.gpos[i].x-_G.campos.x)/_G.camzoom+screenXH
            local ty=(car.debug.gpos[i].y-_G.campos.y)/_G.camzoom+screenYH
            love.graphics.print("sr: "..math.floor((car.debug.sr[i]*10000+0.5))/10000,tx,ty)
            love.graphics.print("sa: "..math.floor((car.debug.sa[i]*100+0.5))/100,tx,ty+15)
            love.graphics.print("rot: "..math.floor((wheel.rot*100+0.5))/100,tx,ty+30)
            love.graphics.print("w: "..math.floor((wheel.w*100+0.5))/100,tx,ty+45)
            love.graphics.print("tq: "..math.floor((car.debug.tq[i]*100+0.5))/100,tx,ty+55)
        end
    end
    local car=_G.cars[1]
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("UPS: "..math.floor((100/avgldt+0.5)/100),100,100)
    love.graphics.print("fps: "..math.floor((100/dt+0.5)/100),200,100)
    love.graphics.print("camzoom: "..math.floor((_G.camzoom*100)+0.5)/100,300,100)
    love.graphics.print("campos: "..math.floor((_G.campos.x*100)+0.5)/100 .. math.floor((_G.campos.y*100)+0.5)/100,300,400)
    love.graphics.print("vel_xy: "..car.vel.x.." "..car.vel.y,10,10)
    local vel_m=math.sqrt(car.vel.x*car.vel.x+car.vel.y*car.vel.y)
    love.graphics.print("vel_m: "..(math.floor(vel_m*1000+.5)/1000).."m/s".."   "..(math.floor(vel_m*1000*3.6+.5)/1000).." km/h",500,10)
    love.graphics.print("rotvel: "..tostring(math.floor(car.rotvel*10000+0.5)/10000).." rad/s",500,30)
    love.graphics.print("rot: "..tostring(math.floor(car.rot*10000+0.5)/10000),30,50)
    love.graphics.print("vel_glob_rot: "..math.floor(math.atan2(car.vel.x, car.vel.y)*10000+0.5)/10000,30,70)
    --love.graphics.print("w: "..math.floor(car.wheelsw["FR"]*10000)/10000,30,90)
    love.graphics.print("slipratio: "..tostring(math.floor(sr*10000+0.5)/10000),30,110)  

    love.graphics.print("engine_rpm: "..tostring(math.floor(_G.cars[1].engine.rpm*10000+0.5)/10000),screenX-200,screenY-50)
    love.graphics.print("gear: "..tostring(_G.cars[1].cgear),screenX-200,screenY-25) 

    local ta=math.sqrt(car.LA.x*car.LA.x+car.LA.y*car.LA.y)/9.81
    love.graphics.print("G's: "..tostring(math.floor(ta*10000+0.5)/10000) .." G",30,130) 
    love.graphics.setColor(0,0,1,1)
    love.graphics.line((car.pos.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y-_G.campos.y)/_G.camzoom+screenYH,(car.pos.x+car.vel.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y+car.vel.y-_G.campos.y)/_G.camzoom+screenYH)
    local carf={
        x=-math.sin(car.rot+math.pi),--math.sin(car.rot),
        y=math.cos(car.rot+math.pi)--+math.cos(car.rot)
}
    love.graphics.setColor(1,1,1,1)
    love.graphics.line((car.pos.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y-_G.campos.y)/_G.camzoom+screenYH,(car.pos.x+carf.x-_G.campos.x)/_G.camzoom+screenXH,(car.pos.y+carf.y-_G.campos.y)/_G.camzoom+screenYH)

    
end

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local lag = 0.0
    local previus_updt=love.timer.getTime() 
    -- Main loop time.
    return function()

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
        
        local ddt=love.timer.step()
        lag = lag + ddt

        while lag >= TICK_RATE*0.5 do
            if love.update then love.update(TICK_RATE) end
            lag = lag - TICK_RATE
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
 
            if love.draw then love.draw(ddt) end
            love.graphics.present()
        end

        ---if love.timer then love.timer.sleep(0.001) end
    end
end
