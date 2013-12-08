// Sistema de cansancio realista por Zume-Zero (Dr.Marlboro).

#include <a_samp>
#include <progress>
#include <foreach>

enum Necesidad{
	pCansancio,
};
new Necesidades[MAX_PLAYERS][Necesidad],
	CansadoDetectar[MAX_PLAYERS],
	TimerDetectar,
	HaSpawneado[MAX_PLAYERS],
	/* Barra */ Bar:CansancioB[MAX_PLAYERS] = {INVALID_BAR_ID, ...},
    /* Draws */
	PlayerText:CansancioInfo[MAX_PLAYERS],
	Text:CansancioTD1,
	Text:CansancioTD2;

public OnFilterScriptInit(){
	CansancioTD1 = TextDrawCreate(620.000000, 153.000000, "_");
	TextDrawBackgroundColor(CansancioTD1, 255);
	TextDrawFont(CansancioTD1, 1);
	TextDrawLetterSize(CansancioTD1, 0.400000, 3.300000);
	TextDrawColor(CansancioTD1, -1);
	TextDrawSetOutline(CansancioTD1, 0);
	TextDrawSetProportional(CansancioTD1, 1);
	TextDrawSetShadow(CansancioTD1, 1);
	TextDrawUseBox(CansancioTD1, 1);
	TextDrawBoxColor(CansancioTD1, 125);
	TextDrawTextSize(CansancioTD1, 493.000000, -1.000000);
	TextDrawSetSelectable(CansancioTD1, 0);

	CansancioTD2 = TextDrawCreate(485.000000, 138.000000, "Cansancio");
	TextDrawBackgroundColor(CansancioTD2, 255);
	TextDrawFont(CansancioTD2, 0);
	TextDrawLetterSize(CansancioTD2, 0.610000, 2.500000);
	TextDrawColor(CansancioTD2, -1);
	TextDrawSetOutline(CansancioTD2, 1);
	TextDrawSetProportional(CansancioTD2, 1);
	TextDrawSetSelectable(CansancioTD2, 0);
	print("Sistema de cansancio realista por Zume-Zero");
	TimerDetectar = SetTimer("DetectarCorriendo", 200, 1);
	return 1;
}

public OnFilterScriptExit(){
    KillTimer(TimerDetectar);
	return 1;
}

public OnPlayerConnect(playerid){
    HaSpawneado[playerid] = 0;
    CansadoDetectar[playerid] = 0;
	CansancioInfo[playerid] = CreatePlayerTextDraw(playerid,546.000000, 167.000000, "100%");
	PlayerTextDrawBackgroundColor(playerid,CansancioInfo[playerid], 255);
	PlayerTextDrawFont(playerid,CansancioInfo[playerid], 2);
	PlayerTextDrawLetterSize(playerid,CansancioInfo[playerid], 0.240000, 1.300000);
	PlayerTextDrawColor(playerid,CansancioInfo[playerid], -1);
	PlayerTextDrawSetOutline(playerid,CansancioInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid,CansancioInfo[playerid], 1);
	PlayerTextDrawSetShadow(playerid,CansancioInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid,CansancioInfo[playerid], 0);
	return 1;
}

stock PonerBarras(playerid){
	new string[50];
	CansancioB[playerid] = CreateProgressBar(503.00, 168.00, 105.50, 11.20, -5963521, 100.0);
	ShowProgressBarForPlayer(playerid, CansancioB[playerid]);
	SetProgressBarValue(CansancioB[playerid], Necesidades[playerid][pCansancio]);
	UpdateProgressBar(CansancioB[playerid], playerid);

	format(string, sizeof(string), "%d%", Necesidades[playerid][pCansancio]);
    PlayerTextDrawSetString(playerid, CansancioInfo[playerid], string);
	return 1;
}

stock ActualizarCansancio(playerid){
    new string[50];
	SetProgressBarValue(CansancioB[playerid], Necesidades[playerid][pCansancio]);
	UpdateProgressBar(CansancioB[playerid], playerid);
	
	format(string, sizeof(string), "%d%", Necesidades[playerid][pCansancio]);
    PlayerTextDrawSetString(playerid, CansancioInfo[playerid], string);
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	PlayerTextDrawHide(playerid, CansancioInfo[playerid]);
	DestroyProgressBar(CansancioB[playerid]);
	CansancioB[playerid] = INVALID_BAR_ID;
	return 1;
}

public OnPlayerSpawn(playerid){
    HaSpawneado[playerid] = 1;
    CansadoDetectar[playerid] = 0;
    PlayerTextDrawShow(playerid, CansancioInfo[playerid]);
    TextDrawShowForPlayer(playerid, CansancioTD1);
    TextDrawShowForPlayer(playerid, CansancioTD2);
    Necesidades[playerid][pCansancio] = 0;
    PonerBarras(playerid);
	return 1;
}

forward DetectarCorriendo(playerid);
public DetectarCorriendo(playerid)
{
 	#define ASD_ i
 	foreach(Player, i)
    {
	 	if(HaSpawneado[playerid] == 1)
	 	{
		    if(CansancioB[ASD_] != INVALID_BAR_ID)
		    {
			    if(CansadoDetectar[ASD_] == 1){
			    if(Necesidades[ASD_][pCansancio] <= 0){CansadoDetectar[ASD_] = 0; ClearAnimations(ASD_); return 1;}
			    Necesidades[ASD_][pCansancio] -= 3;
			    return ActualizarCansancio(ASD_);
			    }
				else{
					if(GetPlayerAnimationIndex(ASD_)){
						new Animaciones[32],AnimacionNombre[32];
						GetAnimationName(GetPlayerAnimationIndex(ASD_),Animaciones,32,AnimacionNombre,32);
						if(strcmp(Animaciones, "PED", true) == 0){
							if(strcmp(AnimacionNombre, "RUN_OLD") == 1)
							{
								if(Necesidades[ASD_][pCansancio] == 100){
					            ApplyAnimation(ASD_, "PED","IDLE_tired",3.0,1,0,0,0,0);
					            CansadoDetectar[ASD_] = 1;
					            return GameTextForPlayer(ASD_, "ESTAS CANSADO..", 3000, 3);
								}
								else if(Necesidades[ASD_][pCansancio] > 100){ Necesidades[ASD_][pCansancio] = 100; ActualizarCansancio(ASD_); return 1; }
								Necesidades[ASD_][pCansancio] += 2;
								return ActualizarCansancio(ASD_);
							}
						 	else if(strcmp(AnimacionNombre, "IDLESTANCE_OLD") == 1)
							{
								if(Necesidades[ASD_][pCansancio] == 0) return 1;
								else if(Necesidades[ASD_][pCansancio] < 0){ Necesidades[ASD_][pCansancio] = 0; ActualizarCansancio(ASD_); return 1; }
								Necesidades[ASD_][pCansancio] -= 10;
								return ActualizarCansancio(ASD_);
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

// Sistema de cansancio realista por Zume-Zero (Dr.Marlboro).
