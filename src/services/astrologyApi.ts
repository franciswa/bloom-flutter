import axios from 'axios';
import { BirthData, PlanetPosition, PlanetaryBody, ZodiacSign } from '../types/compatibility';
import { createNatalChartSync, getDefaultPlanetPositions } from './birthData';

// API configuration
const API_BASE_URL = 'https://api.astrologer.com/v1'; // Example API URL
const API_KEY = process.env.EXPO_PUBLIC_ASTROLOGY_API_KEY || '';

// Cache for planetary positions to reduce API calls
interface CacheEntry {
  timestamp: number;
  data: Record<PlanetaryBody, PlanetPosition>;
}

const planetaryPositionsCache: Record<string, CacheEntry> = {};
const CACHE_EXPIRY = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

/**
 * Generate a cache key from birth data
 * @param birthData Birth data
 * @returns Cache key
 */
function generateCacheKey(birthData: BirthData): string {
  return `${birthData.date.toISOString()}_${birthData.time}_${birthData.latitude}_${birthData.longitude}`;
}

/**
 * Check if cached data is valid
 * @param cacheKey Cache key
 * @returns True if cache is valid, false otherwise
 */
function isCacheValid(cacheKey: string): boolean {
  const cacheEntry = planetaryPositionsCache[cacheKey];
  if (!cacheEntry) return false;
  
  const now = Date.now();
  return now - cacheEntry.timestamp < CACHE_EXPIRY;
}

/**
 * Get planetary positions from cache
 * @param cacheKey Cache key
 * @returns Planetary positions or null if not in cache
 */
function getFromCache(cacheKey: string): Record<PlanetaryBody, PlanetPosition> | null {
  if (!isCacheValid(cacheKey)) return null;
  return planetaryPositionsCache[cacheKey].data;
}

/**
 * Store planetary positions in cache
 * @param cacheKey Cache key
 * @param data Planetary positions
 */
function storeInCache(cacheKey: string, data: Record<PlanetaryBody, PlanetPosition>): void {
  planetaryPositionsCache[cacheKey] = {
    timestamp: Date.now(),
    data
  };
}

/**
 * Get planetary positions from API
 * @param birthData Birth data
 * @returns Planetary positions
 */
async function fetchPlanetaryPositions(birthData: BirthData): Promise<Record<PlanetaryBody, PlanetPosition>> {
  try {
    // Check if API key is available
    if (!API_KEY) {
      console.warn('Astrology API key not found. Using default planetary positions.');
      const sunSign = createNatalChartSync(birthData).sign;
      return getDefaultPlanetPositions(sunSign);
    }

    // Format date and time for API
    const date = birthData.date.toISOString().split('T')[0]; // YYYY-MM-DD
    const time = birthData.time; // HH:MM

    // Make API request
    const response = await axios.get(`${API_BASE_URL}/planets`, {
      params: {
        api_key: API_KEY,
        date,
        time,
        latitude: birthData.latitude,
        longitude: birthData.longitude,
        timezone: birthData.timezone
      }
    });

    // Process API response
    const apiData = response.data;
    
    // Map API response to our format
    const planetPositions: Record<PlanetaryBody, PlanetPosition> = {
      Sun: mapApiPlanetData(apiData.planets.sun),
      Moon: mapApiPlanetData(apiData.planets.moon),
      Mercury: mapApiPlanetData(apiData.planets.mercury),
      Venus: mapApiPlanetData(apiData.planets.venus),
      Mars: mapApiPlanetData(apiData.planets.mars),
      Jupiter: mapApiPlanetData(apiData.planets.jupiter),
      Saturn: mapApiPlanetData(apiData.planets.saturn)
    };

    return planetPositions;
  } catch (error) {
    console.error('Error fetching planetary positions:', error);
    
    // Fallback to default positions
    const sunSign = createNatalChartSync(birthData).sign;
    return getDefaultPlanetPositions(sunSign);
  }
}

/**
 * Map API planet data to our format
 * @param apiPlanetData Planet data from API
 * @returns Planet position in our format
 */
function mapApiPlanetData(apiPlanetData: any): PlanetPosition {
  return {
    sign: apiPlanetData.sign as ZodiacSign,
    degree: apiPlanetData.position || 15,
    house: apiPlanetData.house || 1
  };
}

/**
 * Get planetary positions for birth data
 * @param birthData Birth data
 * @returns Planetary positions
 */
export async function getPlanetaryPositions(birthData: BirthData): Promise<Record<PlanetaryBody, PlanetPosition>> {
  const cacheKey = generateCacheKey(birthData);
  
  // Check cache first
  const cachedData = getFromCache(cacheKey);
  if (cachedData) {
    return cachedData;
  }
  
  // Fetch from API if not in cache
  const planetPositions = await fetchPlanetaryPositions(birthData);
  
  // Store in cache
  storeInCache(cacheKey, planetPositions);
  
  return planetPositions;
}

/**
 * Get pre-calculated ephemeris data for a specific date
 * @param date Date to get ephemeris data for
 * @returns Planetary positions
 */
export function getEphemerisData(date: Date): Record<PlanetaryBody, PlanetPosition> {
  // This would typically load from a pre-calculated ephemeris database
  // For now, we'll use the default positions based on sun sign
  const month = date.getMonth();
  const day = date.getDate();
  
  let sunSign: ZodiacSign;
  
  // Very simplified zodiac sign determination
  if ((month === 2 && day >= 21) || (month === 3 && day <= 19)) {
    sunSign = 'Aries';
  } else if ((month === 3 && day >= 20) || (month === 4 && day <= 20)) {
    sunSign = 'Taurus';
  } else if ((month === 4 && day >= 21) || (month === 5 && day <= 20)) {
    sunSign = 'Gemini';
  } else if ((month === 5 && day >= 21) || (month === 6 && day <= 22)) {
    sunSign = 'Cancer';
  } else if ((month === 6 && day >= 23) || (month === 7 && day <= 22)) {
    sunSign = 'Leo';
  } else if ((month === 7 && day >= 23) || (month === 8 && day <= 22)) {
    sunSign = 'Virgo';
  } else if ((month === 8 && day >= 23) || (month === 9 && day <= 22)) {
    sunSign = 'Libra';
  } else if ((month === 9 && day >= 23) || (month === 10 && day <= 21)) {
    sunSign = 'Scorpio';
  } else if ((month === 10 && day >= 22) || (month === 11 && day <= 21)) {
    sunSign = 'Sagittarius';
  } else if ((month === 11 && day >= 22) || (month === 0 && day <= 19)) {
    sunSign = 'Capricorn';
  } else if ((month === 0 && day >= 20) || (month === 1 && day <= 18)) {
    sunSign = 'Aquarius';
  } else {
    sunSign = 'Pisces';
  }
  
  return getDefaultPlanetPositions(sunSign);
}

/**
 * Calculate simplified planetary positions based on birth time
 * @param birthData Birth data
 * @returns Planetary positions
 */
export function calculateSimplifiedPositions(birthData: BirthData): Record<PlanetaryBody, PlanetPosition> {
  const sunSign = createNatalChartSync(birthData).sign;
  const defaultPositions = getDefaultPlanetPositions(sunSign);
  
  // Parse birth time
  const [hours, minutes] = birthData.time.split(':').map(Number);
  const timeOfDay = hours + minutes / 60; // 0-24 range
  
  // Adjust positions based on time of day
  // This is a very simplified approach - real calculations would be much more complex
  const adjustedPositions: Record<PlanetaryBody, PlanetPosition> = { ...defaultPositions };
  
  // Adjust Moon position based on time (Moon moves ~12° per day)
  const moonDegreeAdjustment = (timeOfDay / 24) * 12;
  adjustedPositions.Moon.degree = (defaultPositions.Moon.degree + moonDegreeAdjustment) % 30;
  
  // Adjust Ascendant (rises ~1° every 4 minutes, full 360° in 24 hours)
  // In a real implementation, this would be calculated based on location and time
  const ascendantDegree = (timeOfDay / 24) * 360 % 30;
  const ascendantSignIndex = Math.floor((timeOfDay / 24) * 12);
  const zodiacSigns: ZodiacSign[] = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];
  
  // This would be added to the positions if we tracked Ascendant
  const ascendantSign = zodiacSigns[ascendantSignIndex];
  const ascendantPosition = {
    sign: ascendantSign,
    degree: ascendantDegree,
    house: 1
  };
  
  return adjustedPositions;
}
