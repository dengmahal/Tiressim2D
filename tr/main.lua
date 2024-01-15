local car={
    pos={x=0,y=0},
    vel={x=0,y=-1},
    rot=0,
    rotvel=0,
    mass=1000,
    wheelspos={
        ["FL"]={x=-1,y=-1},
        ["FR"]={x=1,y=-1},
        ["RL"]={x=-1,y=2},
        ["RR"]={x=1,y=2},
    },
    wheelradius=1,
    wheelsw={
        ["FL"]=1,
        ["FR"]=1,
        ["RL"]=1,
        ["RR"]=1,
    },
    tyre_parameters={
        C0 = 15000, -- Base cornering stiffness (in N/deg)
        Fz = 2500, -- Vertical load on the tire (in N)
        D = 1.2, -- Peak stiffness factor
        E = 0.8 -- Curvature factor
      },
      wheelsgpos={
        ["FL"]={x=0,y=0},
        ["FR"]={x=0,y=0},
        ["RL"]={x=0,y=0},
        ["RR"]={x=0,y=0},
    },
    FDD={
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
    LA={x=0,y=0},
    sla=0,
}
_G.campos={x=0,y=0}
_G.camzoom=0.5
function love.load()
    
end
function normalize_angle(angle)
    angle = angle % (2 * math.pi)
    if angle > math.pi then
        angle = angle - 2 * math.pi
    end
    return angle
end
local sr=0
function sign(x)
    return x > 0 and 1 or (x < 0 and -1 or 0)
end
function love.update(dt)
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
    local dd=false
    if love.keyboard.isDown("a") then
        car.rotvel=-1
        dd=true
        --car.rot=car.rot-dt*2
    end
    if love.keyboard.isDown("d") then
        car.rotvel=1
        dd=true
        --car.rot=car.rot+dt*2
    end
    if dd==false then
        car.rotvel=0
    end
    local dddd=false
    if love.keyboard.isDown("w") then
        for i,v in pairs(car.wheelsw)do
            car.wheelsw[i]=car.wheelsw[i]+dt*3
        end
        dddd=true
    end
    if love.keyboard.isDown("s") then
        for i,v in pairs(car.wheelsw)do
            car.wheelsw[i]=car.wheelsw[i]-dt*3
        end
        dddd=true
    end
    if dddd==false then
        for i,v in pairs(car.wheelsw)do
            --car.wheelsw[i]=0
        end
    end
    car.vel.x=car.vel.x+car.LA.x*0.5*dt
    car.vel.y=car.vel.y+car.LA.y*0.5*dt
    car.pos.x=car.pos.x+car.vel.x*0.5*dt
    car.pos.y=car.pos.y+car.vel.y*0.5*dt
    car.rot=car.rot+car.rotvel *0.5*dt

    if car.rot<-math.pi then
        car.rot=math.pi
    elseif car.rot>math.pi then
        car.rot=-math.pi
    end
    
    local TFX=0
    local TFY=0
    for i,v in pairs(car.wheelspos)do
        local wp={ x = (v.x * math.cos(car.rot)) - (v.y * math.sin(car.rot)), y = (v.x * math.sin(car.rot)) + (v.y * math.cos(car.rot)) }
        local wdc=math.sqrt(v.x*v.x+v.y*v.y)
        local linvel={--global
            x = (-(wp.y) * car.rotvel)+car.vel.x ,
            y = ((wp.x) * car.rotvel)+car.vel.y
        }
        local slip_angle = normalize_angle(math.atan2(linvel.x, -linvel.y) - car.rot)
        local linvm=math.sqrt(linvel.x*linvel.x+linvel.y*linvel.y)
        local linvmn=linvel.x*math.sin(car.rot)-linvel.y*math.cos(car.rot)
        if linvmn==0 then linvmn=1e-16 end
        local slipRatio = (car.wheelsw[i] * car.wheelradius - linvmn) / linvmn
        local Fz=car.mass*0.25*-9.81
        local longF=Fz * car.tyre_parameters.D * math.sin(1.9*math.atan(10*slipRatio-car.tyre_parameters.E*(10*slipRatio-math.atan(10*slipRatio))))
        local latF=Fz * car.tyre_parameters.D * math.sin(1.9*math.atan(10*slip_angle-car.tyre_parameters.E*(10*slip_angle-math.atan(10*slip_angle))))
        longF=longF*math.cos(slip_angle)
        car.Flat[i]={ x = (latF * math.cos(car.rot)), y = (latF * math.sin(car.rot))}
        car.FDD[i]={ x = -(longF*math.sin(car.rot)) , y = (longF*math.cos(car.rot))}
        car.wheelsgpos[i].x=wp.x+car.pos.x
        car.wheelsgpos[i].y=wp.y+car.pos.y
        TFX=TFX+(latF * math.cos(car.rot))-(longF*math.sin(car.rot))
        TFY=TFY+(latF * math.sin(car.rot))+(longF*math.cos(car.rot))
        car.sla=slip_angle
        sr=slipRatio
        
    end
    local A={x=TFX/car.mass,y=TFY/car.mass}
    car.LA=A
    car.vel.x=car.vel.x+A.x*0.5*dt
    car.vel.y=car.vel.y+A.y*0.5*dt
    car.pos.x=car.pos.x+car.vel.x*0.5*dt
    car.pos.y=car.pos.y+car.vel.y*0.5*dt
    car.rot=car.rot+car.rotvel *0.5*dt
   --G.campos={x=car.pos.x,y=car.pos.y}
end
function love.draw()
    love.graphics.clear()
    local screenX,screenY=love.graphics.getWidth( ),love.graphics.getHeight( )
    local screenXH,screenYH=screenX*0.5,screenY*0.5
    local corners={
        {x=-0.25,y=-0.25},
        {x=0.25,y=-0.25},
        {x=-0.25,y=0.5},
        {x=0.25,y=0.5},
    }
    for i,v in pairs(car.wheelspos)do
        local ptl={
            x=(((corners[1].x*math.cos(car.rot)-corners[1].y*math.sin(car.rot))+car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
            y=(((corners[1].x*math.sin(car.rot)+corners[1].y*math.cos(car.rot))+car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
        }
        local ptr={
            x=(((corners[2].x*math.cos(car.rot)-corners[2].y*math.sin(car.rot))+car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
            y=(((corners[2].x*math.sin(car.rot)+corners[2].y*math.cos(car.rot))+car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
        }
        local pbl={
            x=(((corners[3].x*math.cos(car.rot)-corners[3].y*math.sin(car.rot))+car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
            y=(((corners[3].x*math.sin(car.rot)+corners[3].y*math.cos(car.rot))+car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
        }
        local pbr={
            x=(((corners[4].x*math.cos(car.rot)-corners[4].y*math.sin(car.rot))+car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom)+screenXH,
            y=(((corners[4].x*math.sin(car.rot)+corners[4].y*math.cos(car.rot))+car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom)+screenYH,
        }
        love.graphics.setLineWidth(2)
        love.graphics.setColor(1,1,1,1)
        love.graphics.polygon("line",ptl.x,ptl.y,ptr.x,ptr.y,pbr.x,pbr.y,pbl.x,pbl.y)
        love.graphics.setColor(0,1,0,1)
        
        love.graphics.line((car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom+screenYH,((car.FDD[i].x*0.001+car.wheelsgpos[i].x)-_G.campos.x)/_G.camzoom+screenXH,((car.FDD[i].y*0.001+car.wheelsgpos[i].y)-_G.campos.y)/_G.camzoom+screenYH)
        love.graphics.setColor(0,0,1,1)
        love.graphics.line((car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom+screenYH,((car.Flat[i].x*0.001+car.wheelsgpos[i].x)-_G.campos.x)/_G.camzoom+screenXH,((car.Flat[i].y*0.001+car.wheelsgpos[i].y)-_G.campos.y)/_G.camzoom+screenYH)
        love.graphics.setColor(1,0,1,0.5)
        love.graphics.setLineWidth(1)
        love.graphics.line((car.wheelsgpos[i].x-_G.campos.x)/_G.camzoom+screenXH,(car.wheelsgpos[i].y-_G.campos.y)/_G.camzoom+screenYH,((car.wheelsw[i]*math.sin(car.rot)*1+car.wheelsgpos[i].x)-_G.campos.x)/_G.camzoom+screenXH,((car.wheelsw[i]*-math.cos(car.rot)*1+car.wheelsgpos[i].y)-_G.campos.y)/_G.camzoom+screenYH)

    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("vel_xy: "..car.vel.x.." "..car.vel.y,10,10)
    love.graphics.print("vel_m: "..(math.floor(math.sqrt(car.vel.x*car.vel.x+car.vel.y*car.vel.y)*1000+.5)/1000).."m/s",500,10)
    love.graphics.print("rotvel: "..tostring(math.floor(car.rotvel*10000)/10000).." rad/s",500,30)
    love.graphics.print("slip_angle: "..tostring(math.floor(car.sla*10000)/10000),30,30)
    love.graphics.print("rot: "..tostring(math.floor(car.rot*10000)/10000),30,50)
    love.graphics.print("vel_glob_rot: "..math.floor(math.atan2(car.vel.x, car.vel.y)*10000)/10000,30,70)
    love.graphics.print("w: "..math.floor(car.wheelsw["FR"]*10000)/10000,30,90)
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