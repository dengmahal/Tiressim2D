local socket=require("socket")
local ffi=require("ffi")
local WindowsGamingInput  = ffi.load("Windows.Gaming.Input.dll")
local TICK_RATE = 1 / 500
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
            q_Bz1=12.035,q_Bz2=-1.33,q_Bz3=0,q_Bz4=0.176,q_Bz5=-0.14853,q_Bz9=34.5,q_Bz10=0,
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
            L_Fz0=1000,         --nominal (rated) load
            L_mux=1,L_muy=1,    --peak friction coefficient
            L_Kxk=1,L_Kyk=1,    --brake slip stiffness
            L_Cx=1,L_Cy=1,      --shape factor
            L_Ex=1,L_Ey=1,      --curvature factor
            L_Hx=1,L_Hy=1,      --horizontal shift
            L_Vx=1,L_Vy=1,      --vertical shift
            L_Kyg=1,            --camber force stiffness
            L_Kzg=1,            --camber torque stiffness
            L_t=1,              --pneumatic trail
            L_Mr=1,             --residual torque
        },
        L_combined_slip={
            L_xa=1,             --slip_angle influence on F_x
            L_yk=1,             --slip_ratio influence on F_y
            L_Vyk=1,            --slip_ratio induced ply-steer F_y
            L_smz=1,            --moment arm of F_x
        },
        L_other={
            L_Cz=1,             --radial tire stiffness
            L_mx=1,             --overturning couple stiffness
            L_VMx=1,            --overturning couple vertical shift
            L_My=1,             --rolling resistance moment
            J_y=0.8,            --reduction factor for camber (the closer the tire to a ball the closer to 0 this should be)
            J_x=0.8,            --reduction factor for camber (the closer the tire to a ball the closer to 0 this should be)
            L_Mfi=1,            --vanisching wheel speed-, constant turning moment
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
            camber=0,
        },
        ["FR"]={
            tyre_params=1,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=0.85,y=-1.01712 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
            camber=0,
        },

        ["RL"]={
            tyre_params=2,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=-0.85,y=1.59088 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
            camber=0,
        },

        ["RR"]={
            tyre_params=2,
            radius=0.4572/2,
            mass=9.3,
            inertria_scale=1,
            x=0.85,y=1.59088 , --->position relative to CG
            w=0, --rad/s
            rot=0, --rad
            camber=0,
        },
    },
    tyre_params={
        [1]={
            D = 1.3, -- Peak stiffness factor
            E = 0.8, -- Curvature factor
            lxal=1,
            lyka=0.5,

        },
        [2]={
            D = 1.3, -- Peak stiffness factor
            E = 0.8, -- Curvature factor
            lxal=1,
            lyka=0.5,

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
function love.load(arg,unfilteredArg)
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
    avgldt=((avgldt*9)+dt) /10
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
    local wettness=0 --update this, its not a constant
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
            local slip_angle = normalize_angle(math.fastatan2(linvel.x, -linvel.y) -car.rot -wheel.rot)
            local linvm=math.sqrt(linvel.x*linvel.x+linvel.y*linvel.y)
            local linvmn=linvel.x*math.sin(car.rot)-linvel.y*math.cos(car.rot)
            local V_x=linvel.x*math.sin(car.rot+wheel.rot)-linvel.y*math.cos(car.rot+wheel.rot)
            if linvmn==0 then linvmn=1e-16 end
            local slipRatio = (wheel.w * wheel.radius - linvmn) / linvmn
            local Fz=car.mass*0.25*-9.81 
            local fz=0
            --tempratur
            local T_d=(wheel.tempratur-tp_te.T_ref)/tp_te.T_ref
            local T_d2=T_d*T_d
            local T_d4=T_d2*T_d2
            local BTM=(1+tp_te.T_1*T_d2+tp_te.T_2*T_d4)
            local abstd5=math.abs(T_d)+T_d
            local abstd6=-math.abs(T_d)+T_d
            local DTD=1+tp_te.T_3*T_d2+tp_te.T_4*T_d4+abstd5*abstd5*tp_te.T_5-abstd6*abstd6*tp_te.T_6

            --#magic formula
            local YS=math.sin(wheel.camber)
            local Y=wheel.camber
            --turn slip
            local R=0 -- radius of curvature
            local fi_t=car.rotvel+wheel.wheelrate     -- -1/R
            local J_Y=tp_ts.p_Egfi1*(1+tp_ts.p_Egfi2*fz)
            local fi=-(1/linvm)*(car.rotvel-(1-J_Y)*wheel.w*YS)
            local absfi=math.abs(fi)
            local B_yfi=tp_ts.p_Dyfi1*(1+tp_ts.p_Dxfi2*fz)*math.cos(math.atan(tp_ts.p_Dxfi3*math.tan(slip_angle)))
            local Z3=math.cos(math.atan(tp_ts.p_Kyfi1*wheel.radius*wheel.radius*fi*fi))
            local C_Hyfi=tp_ts.p_Hyfi1
            local D_Hyfi=(tp_ts.p_Hyfi2+tp_ts.p_Hyfi3*fz)*math.sign(slipRatio)
            local E_Hyfi=tp_ts.p_Hyfi4
            local K_yRfio=K_yY0/(1-J_Y)
            local B_Hyfi=K_yRfio/(C_Hyfi*D_Hyfi*K_ya)
            local Z2=math.cos(math.atan(B_yfi*(wheel.radius*absfi+tp_ts.p_Dyfi4*math.sqrt(wheel.radius*absfi))))
            local S_Hyfi=D_Hyfi*math.sin(C_Hyfi*math.atan(B_Hyfi*wheel.radius*fi-E_Hyfi*(B_Hyfi*wheel.radius*fi-math.atan(B_Hyfi*wheel.radius*fi))))*math.sign(V_x)
            local S_VyY=Fz*(tp_ts.p_Vy3+tp_ts.p_Vy4*fz)*YS*Z2*tp_Lp.L_Kyg*tp_Lp.L_muy
            local S_Hy=(tp_la.p_Hy1+tp_la.p_Hy2*fz)*tp_Lp.L_Hy+S_Hyfi-(S_VyY/K_ya)
            local Z4=1+S_Hyfi-(S_VyY/K_ya)
            local Z5=math.cos(math.atan(tp_ts.q_Drfi1*wheel.radius*fi))
            local M_zfii=tp_ts.q_Crfi1*muy*wheel.radius*Fz*math.sqrt(Fz/tp_Lp.L_Fz0)*tp_Lo.L_mfi
            local C_Drfi=tp_ts.q_Drfi1
            local E_Drfi=tp_ts.q_Drfi2
            local D_Drfi=M_zfii/math.sin(0.5*math.pi*C_Drfi)
            local J_r=10e-10
            local K_zYyo=Fz*wheel.radius*(tp_al.q_Dz8+tp_al.q_Dz9*fz+(tp_la.q_Dz10+tp_la.q_Dz11*fz)*math.abs(Y))*tp_Lp.L_Kzg
            local B_Drfi=K_zYyo/(C_Drfi*D_Drfi*(1-J_Y)+J_r)
            local D_rfi=D_Drfi*math.sin(C_Drfi-math.atan(B_Drfi*wheel.radius*fi-E_Drfi*(B_Drfi*wheel.radius*fi-math.atan(B_Drfi*wheel.radius*fi))))
            local Z8=1+D_rfi
            local K_zYoo=K_zYo-D_to*K_zYyo
            local K_zRfio=K_zYoo/(1-J_Y)
            local Z6=math.cos(math.atan(tp_ts.q_Brfi1*wheel.radius*fi))
            local M_zfi90=M_zfi*(2/math.pi)*math.atan(tp_ts.q_Crfi2*wheel.radius*math.abs(fi_t))*G_yk
            local Z7=(2/math.pi)*math.acos(M_zfi90/(math.abs(D_rfi)+J_r))
            local B_xfi=tp_ts.p_Dxfi1*(1+tp_ts.p_Dxfi2*fz)*math.cos(math.atan(tp_ts.p_Dxfi3*slipRatio))
            local Z1=math.cos(math.atan(B_xfi*wheel.radius*fi))
            
            --long_pure
            
            local S_Vx=Fz*(tp_lo.p_Vx1+tp_lo.p_Vx2)*tp_Lp.L_Vx*tp_Lp.L_mux*Z1
            local S_Hx=(tp_lo.p_Hx1+tp_lo.p_Hx2*fz)*tp_Lp.L_Hx
            local K_x=slipRatio+S_Hx
            local K_xk=Fz*(tp_lo.p_Kx1+tp_lo.p_Kx2*fz)*math.exp(tp_lo.p_Kx3*fz)*(1+tp_lo.p_px1*p_di+tp_lo.p_px2*p_di*p_di)*tp_lo.L_Kxk
            local m_x=(tp_lo.p_Dx1+tp_lo.p_Dx2*fz*fz)*(1+tp_lo.p_px3*p_di*p_di)*(1+tp_lo.p_Dx3*Y*Y)*tp_Lp.L_mux
            local D_x=m_x*Fz*Z1
            local E_x=(tp_lo.p_Ex1+tp_lo.p_Ex2*fz+tp_lo.p_Ex3*fz*fz)*(1-tp_lo.p_Ex4*sign(K_x))*tp_Lp.L_Ex
            local C_x=tp_lo.p_Cx1*tp_Lp.L_Cx
            local B_x=K_xk/(C_x*D_x+tp_Lo.J_x)
            local B_xt=B_x*BTM
            local D_xt=D_x/DTD
            local E_xw=E_x-E_x*tp_we.W_E*wettness
            local D_xtw=D_xt/(1+tp_we.W_D*wettness*wettness)
            local C_xw=C_x+C_x*tp_we.W_C*wettness
            local B_xtw=B_xt+B_xt*tp_we.W_B*wettness
            local F_x0=D_xtw*math.sin(C_xw*math.atan(B_xtw*K_x-E_xw*(B_xtw*K_x-math.atan(B_xtw*K_x))))+S_Vx
            --
            --[[old code
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
        end
    end
    local car=_G.cars[1]
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("UPS: "..math.floor((100/avgldt)/100+0.5),100,100)
    love.graphics.print("fps: "..math.floor((100/dt)/100+0.5),200,100)
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

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local lag = 0.0

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

        while lag >= TICK_RATE do
            if love.update then love.update(TICK_RATE) end
            lag = lag - TICK_RATE
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
 
            if love.draw then love.draw(ddt) end
            love.graphics.present()
        end

        --if love.timer then love.timer.sleep(0.001) end
    end
end
