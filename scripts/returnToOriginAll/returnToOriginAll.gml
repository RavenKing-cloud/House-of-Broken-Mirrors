// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function returnToOriginAll(){
	instance_deactivate_all(true);
	instance_activate_object(oDeathWipe);
	instance_activate_object(oIntroWipe);
	instance_activate_object(oCamBox);
	instance_activate_object(oCamera);
	instance_activate_region(oPlayer.currentCamBox.bbox_left,oPlayer.currentCamBox.bbox_top,oPlayer.currentCamBox.sprite_width,oPlayer.currentCamBox.sprite_height,true);
	returnToOrigin(oEnemy);
	returnToOrigin(oMirCreeper);
	returnToOrigin(oMirShadow);
	returnToOrigin(oSpikeTrap);
	returnToOrigin(oMirCrumble);
	returnToOrigin(oGate_parent);
}