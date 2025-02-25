import { BirthData, ZodiacSign, ZodiacDateRanges, NatalChartData } from '../types/compatibility';
import { getPlanetaryPositions, getEphemerisData, calculateSimplifiedPositions } from './astrologyApi';

// Check if a date falls within a date range that may span across year boundary
function isDateInRange(
  date: Date,
  startMonth: number,
  startDay: number,
  endMonth: number,
  endDay: number
): boolean {
  const month = date.getMonth();
  const day = date.getDate();

  // Handle ranges that cross year boundary (e.g., Capricorn: Dec 22 - Jan 19)
  if (startMonth > endMonth) {
    return (
      (month === startMonth && day >= startDay) ||
      (month === endMonth && day <= endDay) ||
      (month > startMonth) ||
      (month < endMonth)
    );
  }

  // Handle ranges within the same year
  return (
    (month === startMonth && day >= startDay) ||
    (month === endMonth && day <= endDay) ||
    (month > startMonth && month < endMonth)
  );
}

// Calculate zodiac sign from birth date
export function calculateZodiacSign(birthDate: Date): ZodiacSign {
  const zodiacSign = ZodiacDateRanges.find(range =>
    isDateInRange(birthDate, range.startMonth, range.startDay, range.endMonth, range.endDay)
  );

  if (!zodiacSign) {
    throw new Error('Invalid birth date');
  }

  return zodiacSign.sign;
}

// Generate default planet positions based on sun sign
export function getDefaultPlanetPositions(sunSign: ZodiacSign) {
  return {
    Sun: { sign: sunSign, degree: 15, house: 1 },
    Moon: { sign: sunSign, degree: 15, house: 1 },
    Mercury: { sign: sunSign, degree: 15, house: 1 },
    Venus: { sign: sunSign, degree: 15, house: 1 },
    Mars: { sign: sunSign, degree: 15, house: 1 },
    Jupiter: { sign: sunSign, degree: 15, house: 1 },
    Saturn: { sign: sunSign, degree: 15, house: 1 }
  };
}

// Create natal chart from birth data
export async function createNatalChart(birthData: BirthData): Promise<NatalChartData> {
  const sunSign = calculateZodiacSign(birthData.date);
  
  try {
    // Try to get accurate planetary positions using the API
    const planetPositions = await getPlanetaryPositions(birthData);
    
    return {
      birthData,
      sign: sunSign,
      planetPositions
    };
  } catch (error) {
    console.warn('Error getting planetary positions from API, falling back to alternatives:', error);
    
    try {
      // Try to use pre-calculated ephemeris data
      const planetPositions = getEphemerisData(birthData.date);
      
      return {
        birthData,
        sign: sunSign,
        planetPositions
      };
    } catch (ephemerisError) {
      console.warn('Error using ephemeris data, falling back to simplified calculations:', ephemerisError);
      
      try {
        // Try to use simplified calculations based on birth time
        const planetPositions = calculateSimplifiedPositions(birthData);
        
        return {
          birthData,
          sign: sunSign,
          planetPositions
        };
      } catch (simplifiedError) {
        console.warn('Error using simplified calculations, falling back to default positions:', simplifiedError);
        
        // Fall back to default positions
        return {
          birthData,
          sign: sunSign,
          planetPositions: getDefaultPlanetPositions(sunSign)
        };
      }
    }
  }
}

// Create natal chart from birth data synchronously (for backward compatibility)
export function createNatalChartSync(birthData: BirthData): NatalChartData {
  const sunSign = calculateZodiacSign(birthData.date);
  
  try {
    // Try to use simplified calculations based on birth time
    const planetPositions = calculateSimplifiedPositions(birthData);
    
    return {
      birthData,
      sign: sunSign,
      planetPositions
    };
  } catch (error) {
    console.warn('Error using simplified calculations, falling back to default positions:', error);
    
    // Fall back to default positions
    return {
      birthData,
      sign: sunSign,
      planetPositions: getDefaultPlanetPositions(sunSign)
    };
  }
}

// Validate birth data
export function validateBirthData(data: BirthData): boolean {
  const { date, time, latitude, longitude, timezone } = data;

  // Validate date
  if (!(date instanceof Date) || isNaN(date.getTime())) {
    return false;
  }

  // Validate time format (HH:mm)
  const timeRegex = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/;
  if (!timeRegex.test(time)) {
    return false;
  }

  // Validate latitude (-90 to 90)
  if (latitude < -90 || latitude > 90) {
    return false;
  }

  // Validate longitude (-180 to 180)
  if (longitude < -180 || longitude > 180) {
    return false;
  }

  // Validate timezone (IANA timezone string)
  try {
    Intl.DateTimeFormat(undefined, { timeZone: timezone });
  } catch (e) {
    return false;
  }

  return true;
}

// Format birth data for display
export function formatBirthData(data: BirthData): string {
  const date = data.date.toLocaleDateString();
  const location = `${data.latitude.toFixed(4)}°, ${data.longitude.toFixed(4)}°`;
  return `Born on ${date} at ${data.time} (${data.timezone})\nLocation: ${location}`;
}
