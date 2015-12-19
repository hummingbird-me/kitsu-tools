import config from 'client/config/environment';

// Support for Docker development
export default function getApiHost() {
  if (config.apiHost !== undefined) {
    return config.apiHost;
  }
  return `http://${window.location.hostname}:3000`;
}
