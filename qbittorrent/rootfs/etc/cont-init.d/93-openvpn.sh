#!/usr/bin/with-contenv bashio
# ==============================================================================

declare openvpn_config
declare openvpn_username
declare openvpn_password

if bashio::config.true 'openvpn_enabled'; then
  
  bashio::log.info "Configuring openvpn"

  # CONFIGURE OPENVPN
  openvpn_config=$(bashio::config 'openvpn_config')

  cp "/config/openvpn/${openvpn_config}" /etc/openvpn/config.ovpn ||   bashio::log.error "openvpn config file not found in /config/openvpn/${openvpn_config}"

  openvpn_username=$(bashio::config 'openvpn_username')
  echo "${openvpn_username}" > /etc/openvpn/credentials
  openvpn_password=$(bashio::config 'openvpn_password')
  echo "${openvpn_password}" >> /etc/openvpn/credentials

  sed -i 's/auth-user-pass.*/auth-user-pass \/etc\/openvpn\/credentials/g' /etc/openvpn/config.ovpn
  touch /etc/openvpn/up.sh
  touch /etc/openvpn/down.sh
  sed -i "1a\/etc/openvpn/up-qbittorrent.sh \"\${4}\" &\n" /etc/openvpn/up.sh
  bashio::log.info "openvpn correctly set, please modify manually qbittorrent options to select it"

  # CONFIGURE QBITTORRENT
  port="$1"

  QBT_CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"
  if [ -f "$QBT_CONFIG_FILE" ]; then
      # if Connection address line exists
      if grep -q 'Connection\\PortRangeMin' "$QBT_CONFIG_FILE"; then
          # Set connection interface address to the VPN address
          sed -i -E 's/^.*\b(Connection.*PortRangeMin)\b.*$/Connection\\PortRangeMin='"$port"'/' "$QBT_CONFIG_FILE"
      else
          # add the line for configuring interface address to the qBittorrent config file
          printf 'Connection\\PortRangeMin=%s' "$port" >>"$QBT_CONFIG_FILE"
      fi
  else
      bashio::log.error "qBittorrent config file doesn't exist, openvpn must be added manually to qbittorrent options "
      exit 1
  fi
else
  # Ensure no redirection by removing the direction tag
  bashio::log.info "Direct connection without VPN enabled"
  sed -i '/PortRangeMin/d' $QBT_CONFIG_FILE
fi
