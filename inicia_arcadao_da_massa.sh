#!/bin/bash
# Inicia o xboxdrv
# 2021-11-19 => Paulo Sergio Travaglia

# Obs: Meu arcade e homemade e foi feito usando um
# controle generico
# (Bus 003 Device 005: ID 0079:0006 DragonRise Inc. PC TWIN SHOCK Gamepad)

#####
# CFG
#####
ARQ_CFG=config_xboxdrv_arcade.ini
DEVICE_STRING="DragonRise_Inc._Generic_USB_Joystick"
DIR_INPUTDEV_BASE="/dev/input/"

##########
# PRINCIPAL
##########
v_dir_script="$(dirname $0)"

if [ ! -s ${v_dir_script}/${ARQ_CFG} ]
then
  echo "Arquivo de CFG nao encontrado (${v_dir_script}/${ARQ_CFG}) - verifique se esta no mesmo dir do script, permissoes, etc"
  exit 1
fi

# Localiza o event device
ls -l ${DIR_INPUTDEV_BASE}/by-id | grep -i "${DEVICE_STRING}" | grep event
if [ $? -ne 0 ]
then
  echo "Nao localizei o event device ${DEVICE_STRING} em ${DIR_INPUTDEV_BASE}/by-id"
  exit 2
fi

v_evdev=$(ls -l ${DIR_INPUTDEV_BASE}/by-id | grep -i "${DEVICE_STRING}" | grep event | awk '{print $NF}')
v_evdev_tmp=$(basename ${v_evdev})
v_evdev=${DIR_INPUTDEV_BASE}/${v_evdev_tmp}
echo "##############################################################################"
echo "Arquivo de configuracao: ${v_dir_script}/${ARQ_CFG}"
echo "EVDEV em uso: ${v_evdev}"
echo "Aguarde uns 60 segundos para enumerar os dispositivos ou pegue uma versao alterada no xboxdrv..."
echo "Ref: https://github.com/xboxdrv/xboxdrv/pull/214"
echo "##############################################################################"

xboxdrv  --silent --evdev ${v_evdev} --config ${v_dir_script}/${ARQ_CFG} --mimic-xpad
if [ $? -ne 0 ]
then
  echo "Problemas ao executar o xboxdrv - Verifique:"
  echo " - Se o xboxdrv esta instalado"
  echo " - Se ha permissoes no grupo do dispositivo para o usuario ${USER} (normalmente grupo input)"
  echo " - Se o event device foi mapeado corretamente pelo script (${v_evdev} - Confira em ${DIR_INPUTDEV_BASE}/by-id"
  exit 3
fi
