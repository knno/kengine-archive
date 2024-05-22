/**
 * @name Scrollbar
 * @private
 * @memberof Kengine.Extensions.Panels
 * @new_name Kengine.Extensions.Panels.Scrollbar
 * @description A scrollbar displayed on-demand for panels.
 * 
 */
function __KenginePanelsScrollbar(type, value, spr, mw_enabled) constructor {
    self.type = type
    self.value = value
    self.spr = spr
    self.mw_enabled = mw_enabled
    self.visible = true

    /**
     * @function DrawSlots
     * @memberof Kengine.Extensions.Panels.Scrollbar
     * 
     */
    DrawSlots = function (x,y, len, slots, maxslots) {
        var sb,xx,yy,swh,s,ms,wh,mwh,spr,sw,sh,sel,sel2,a,sp,ep,tp;
        sb=self

        if not sb.visible return

        var mouse_xx,mouse_yy;
        mouse_xx=mouse_x
        mouse_yy=mouse_y
        xx=x
        yy=y
        swh=len
        s=slots
        ms=maxslots
        wh=s*swh
        mwh=ms*swh
        tp=sb.type
        spr=sb.spr
        sw=sprite_get_width(spr)
        sh=sprite_get_height(spr)

        if (Kengine.Extensions.Panels.__scrollbar_current=sb) {
            Kengine.Extensions.Panels.__scrollbar_timer=max(0,(Kengine.Extensions.Panels.__scrollbar_timer-1)*mouse_check_button(mb_left))
        }
        for (a=((xx+sw)*(tp=0))+((yy+sh)*(tp>0)); a<((xx+wh+sw)*(tp=0))+((yy+wh+sh)*(tp>0)); a+=2) {
            draw_sprite(spr,(15*(tp=0))+(19*(tp>0)),(a*(tp=0))+(xx*(tp>0)),(yy*(tp=0))+(a*(tp>0)))
        }
        if (!mouse_check_button(mb_left) && Kengine.Extensions.Panels.__scrollbar_drag>-1) {
            Kengine.Extensions.Panels.__scrollbar_drag=-1
        }
        if (mwh>wh && wh>0) {
            sp=(((xx+sw)*(tp=0))+((yy+sh)*(tp>0)))+(sb.value*((s/ms)*swh))
            ep=sp+max((wh*(wh/mwh)),4)
            if (Kengine.Extensions.Panels.__scrollbar_drag=sb && ((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))>=((xx+sw)*(tp=0))+((yy+sh)*(tp>0)) && ((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))<((xx+(sw*2)+wh)*(tp=0))+((yy+(sh*2)+wh)*(tp>0))) {
                sb.value+=((((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))-((Kengine.Extensions.Panels.__scrollbar_mxprev*(tp=0))+(Kengine.Extensions.Panels.__scrollbar_myprev*(tp>0)))))/(wh/ms)
                Kengine.Extensions.Panels.__scrollbar_mxprev=mouse_xx
                Kengine.Extensions.Panels.__scrollbar_myprev=mouse_yy
            }
            if (Kengine.Extensions.Panels.__scrollbar_current=sb && sb.mw_enabled>0) {
                sb.value+=15*((-1*mouse_wheel_up())+(1*mouse_wheel_down()))
            }
            sel=(Kengine.Extensions.Panels.__scrollbar_drag=-1 && (mouse_xx*(tp=0))+(mouse_yy*(tp>0))>=((xx+sw)*(tp=0))+((yy+sh)*(tp>0)) && (mouse_xx*(tp=0))+(mouse_yy*(tp>0))<sp && mouse_check_button(mb_left) && (mouse_yy*(tp=0))+(mouse_xx*(tp>0))>(yy*(tp=0))+(xx*(tp>0)) && (mouse_yy*(tp=0))+(mouse_xx*(tp>0))<((yy+sh)*(tp=0))+((xx+sh)*(tp>0)))
            sel+=2*(Kengine.Extensions.Panels.__scrollbar_drag=-1 && (mouse_xx*(tp=0))+(mouse_yy*(tp>0))>ep && (mouse_xx*(tp=0))+(mouse_yy*(tp>0))<((xx+sw+wh)*(tp=0))+((yy+sh+wh)*(tp>0)) && mouse_check_button(mb_left) && (mouse_yy*(tp=0))+(mouse_xx*(tp>0))>(yy*(tp=0))+(xx*(tp>0)) && (mouse_yy*(tp=0))+(mouse_xx*(tp>0))<((yy+sh)*(tp=0))+((xx+sh)*(tp>0)))
            if (sel>0 && Kengine.Extensions.Panels.__scrollbar_timer=0) {
                sb.value+=(-1*(sel=1))+(1*(sel=2))
                sb.value=max(0,min(ms-s,sb.value))
                Kengine.Extensions.Panels.__scrollbar_timer=ceil(fps/(15-(12*mouse_check_button_pressed(mb_left))))
                Kengine.Extensions.Panels.__scrollbar_current=sb
            }
            sb.value=min(ms-s,max(0,sb.value))
            if (Kengine.Extensions.Panels.__scrollbar_drag<>sb) {
                sb.value=round(sb.value)
            }
            sp=(((xx+sw)*(tp=0))+((yy+sh)*(tp>0)))+(sb.value*((s/ms)*swh))
            ep=sp+max((wh*(wh/mwh)),4)
            for (a=floor(sp+1); a<=ceil(ep-2); a+=1) {
                draw_sprite(spr,(13*(tp=0))+(17*(tp>0)),(a*(tp=0))+(xx*(tp>0)),(yy*(tp=0))+(a*(tp>0)))
            }
            draw_sprite(spr,(12*(tp=0))+(16*(tp>0)),(floor(sp)*(tp=0))+(xx*(tp>0)),(floor(sp)*(tp>0))+(yy*(tp=0)))
            draw_sprite(spr,(14*(tp=0))+(18*(tp>0)),((ceil(ep)-2)*(tp=0))+(xx*(tp>0)),((ceil(ep)-2)*(tp>0))+(yy*(tp=0)))
            sel=(((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))>=sp && ((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))<ep && ((mouse_yy*(tp=0))+(mouse_xx*(tp>0)))>=(yy*(tp=0))+(xx*(tp>0)) && ((mouse_yy*(tp=0))+(mouse_xx*(tp>0)))<((yy+sh)*(tp=0))+((xx+sw)*(tp>0)) && mouse_check_button_pressed(mb_left))
            if (sel=1 && Kengine.Extensions.Panels.__scrollbar_drag=-1) {
                Kengine.Extensions.Panels.__scrollbar_current=sb
                Kengine.Extensions.Panels.__scrollbar_drag=sb
                Kengine.Extensions.Panels.__scrollbar_mxprev=mouse_xx
                Kengine.Extensions.Panels.__scrollbar_myprev=mouse_yy
            }
        } else if (Kengine.Extensions.Panels.__scrollbar_drag=sb) {
            Kengine.Extensions.Panels.__scrollbar_drag=-1
        }
        sel=(((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))>=(xx*(tp=0))+(yy*(tp>0)) && ((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))<((xx+sw)*(tp=0))+((yy+sh)*(tp>0)) && ((mouse_yy*(tp=0))+(mouse_xx*(tp>0)))>=(yy*(tp=0))+(xx*(tp>0)) && ((mouse_yy*(tp=0))+(mouse_xx*(tp>0)))<((yy+sh)*(tp=0))+((xx+sw)*(tp>0)) && mouse_check_button(mb_left) && Kengine.Extensions.Panels.__scrollbar_drag=-1 && mwh>wh)
        sel2=(((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))>=((xx+wh+sw)*(tp=0))+((yy+wh+sh)*(tp>0)) && ((mouse_xx*(tp=0))+(mouse_yy*(tp>0)))<((xx+(sw*2)+wh)*(tp=0))+((yy+(sh*2)+wh)*(tp>0)) && ((mouse_yy*(tp=0))+(mouse_xx*(tp>0)))>=(yy*(tp=0))+(xx*(tp>0)) && ((mouse_yy*(tp=0))+(mouse_xx*(tp>0)))<((yy+sh)*(tp=0))+((xx+sw)*(tp>0)) && mouse_check_button(mb_left) && Kengine.Extensions.Panels.__scrollbar_drag=-1 && mwh>wh)
        if (sel+sel2>0 && Kengine.Extensions.Panels.__scrollbar_timer=0) {
            sb.value+=(-1*(sel=1))+(1*(sel2=1))
            sb.value=max(0,min(ms-s,sb.value))
            Kengine.Extensions.Panels.__scrollbar_timer=ceil(fps/(15-(12*mouse_check_button_pressed(mb_left))))
            Kengine.Extensions.Panels.__scrollbar_current=sb
        }
        draw_sprite(spr,(0*(tp=0))+(6*(tp>0))+(sel>0 || mwh<=wh)+(mwh<=wh),xx,yy)
        draw_sprite(spr,(3*(tp=0))+(9*(tp>0))+(sel2>0 || mwh<=wh)+(mwh<=wh),((xx+wh+sw)*(tp=0))+(xx*(tp>0)),(yy*(tp=0))+((yy+wh+sh)*(tp>0)))
    }
}

