import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['autocomplete', 'street', 'town', 'state', 'postcode', 'country']

  connect() {
    if (window.google && window.google.maps && window.google.maps.places) {
      this.initAutocomplete();
    } else {
      document.addEventListener('googleMapsLoaded', this.initAutocomplete.bind(this));
    }

    // Add keydown listener to the autocomplete target
    this.autocompleteTarget.addEventListener('keydown', this.handleKeyDown.bind(this));
  }

  handleKeyDown(event) {
    // If the key pressed was Enter, prevent the whole form from submitting
    if (event.key === 'Enter') {
      event.preventDefault();
    }
  }

  initAutocomplete() {
    this.autocomplete = new google.maps.places.Autocomplete(this.autocompleteTarget, {
      componentRestrictions: { country: 'au' }
    });
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
  }

  placeChanged() {
    const place = this.autocomplete.getPlace()

    // Get the address components from the place object
    const subpremise = place.address_components.find(component => component.types.includes('subpremise'))?.long_name || '';
    const streetNumber = place.address_components.find(component => component.types.includes('street_number'))?.long_name || '';
    const route = place.address_components.find(component => component.types.includes('route'))?.long_name || '';
    const city = place.address_components.find(component => component.types.includes('locality'))?.long_name || '';
    const state = place.address_components.find(component => component.types.includes('administrative_area_level_1'))?.short_name || '';
    const postalCode = place.address_components.find(component => component.types.includes('postal_code'))?.long_name || '';
    const country = place.address_components.find(component => component.types.includes('country'))?.long_name || '';

    // Combine the subpremise (if present), streetNumber, and route to form the full street address
    const streetAddress = subpremise
      ? `${subpremise}/${streetNumber} ${route}`.trim()
      : `${streetNumber} ${route}`.trim();

    // Set the values to the corresponding targets
    this.streetTarget.value = streetAddress;
    this.townTarget.value = city;
    this.stateTarget.value = state;
    this.postcodeTarget.value = postalCode;
    this.countryTarget.value = country;
  }

  get autocompleteTarget() {
    return this.targets.find('autocomplete')
  }

  get streetTarget() {
    return this.targets.find('street')
  }

  get townTarget() {
    return this.targets.find('town')
  }

  get stateTarget() {
    return this.targets.find('state')
  }

  get postcodeTarget() {
    return this.targets.find('postcode')
  }

  get countryTarget() {
    return this.targets.find('country')
  }
}
