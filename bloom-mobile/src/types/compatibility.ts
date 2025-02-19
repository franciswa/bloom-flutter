// Birth Data
export interface BirthData {
  date: Date;
  time: string; // HH:mm format
  latitude: number;
  longitude: number;
  timezone: string;
}

// Zodiac Signs
export type ZodiacSign = 
  | 'Aries' 
  | 'Taurus' 
  | 'Gemini' 
  | 'Cancer' 
  | 'Leo' 
  | 'Virgo'
  | 'Libra' 
  | 'Scorpio' 
  | 'Sagittarius' 
  | 'Capricorn' 
  | 'Aquarius' 
  | 'Pisces';

// Date ranges for zodiac signs
export const ZodiacDateRanges: Array<{
  sign: ZodiacSign;
  startMonth: number; // 0-11
  startDay: number;   // 1-31
  endMonth: number;   // 0-11
  endDay: number;     // 1-31
}> = [
  { sign: 'Aries', startMonth: 2, startDay: 21, endMonth: 3, endDay: 19 },
  { sign: 'Taurus', startMonth: 3, startDay: 20, endMonth: 4, endDay: 20 },
  { sign: 'Gemini', startMonth: 4, startDay: 21, endMonth: 5, endDay: 20 },
  { sign: 'Cancer', startMonth: 5, startDay: 21, endMonth: 6, endDay: 22 },
  { sign: 'Leo', startMonth: 6, startDay: 23, endMonth: 7, endDay: 22 },
  { sign: 'Virgo', startMonth: 7, startDay: 23, endMonth: 8, endDay: 22 },
  { sign: 'Libra', startMonth: 8, startDay: 23, endMonth: 9, endDay: 22 },
  { sign: 'Scorpio', startMonth: 9, startDay: 23, endMonth: 10, endDay: 21 },
  { sign: 'Sagittarius', startMonth: 10, startDay: 22, endMonth: 11, endDay: 21 },
  { sign: 'Capricorn', startMonth: 11, startDay: 22, endMonth: 0, endDay: 19 },
  { sign: 'Aquarius', startMonth: 0, startDay: 20, endMonth: 1, endDay: 18 },
  { sign: 'Pisces', startMonth: 1, startDay: 19, endMonth: 2, endDay: 20 }
];

// Planetary Bodies
export type PlanetaryBody =
  | 'Sun'
  | 'Moon'
  | 'Mercury'
  | 'Venus'
  | 'Mars'
  | 'Jupiter'
  | 'Saturn';

// Combined Sign type for compatibility calculations
export type Sign = ZodiacSign | PlanetaryBody;

// Astrological Elements  
export type Element = 'Fire' | 'Earth' | 'Air' | 'Water';

// Aspect Types
export enum AspectType {
  CONJUNCTION = 0,   // 0°
  SEXTILE = 60,      // 60°
  SQUARE = 90,       // 90°
  TRINE = 120,       // 120°
  OPPOSITION = 180   // 180°
}

// Planet Position
export interface PlanetPosition {
  sign: ZodiacSign;
  degree: number;
  house: number;
}

// Natal Chart
export interface NatalChart {
  planetPositions: Record<PlanetaryBody, PlanetPosition>;
}

// Aspect Detail
export interface AspectDetail {
  planet1: PlanetaryBody;
  planet2: PlanetaryBody;
  aspectType: AspectType;
  score: number;
}

// Houses for Synastry
export type House = 1 | 5 | 7 | 8;

// Vedic Astrology Types
export type Guna = 'Sattva' | 'Rajas' | 'Tamas';
export type Nakshatra = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27;

// Vedic Attributes
export interface VedicAttributes {
  guna: Guna;
  nakshatra: Nakshatra;
  planetaryRuler: PlanetaryBody;
}

// House Position
export interface HousePosition {
  sign: ZodiacSign;
  house: House;
}

// Base Compatibility Score
export interface BaseCompatibilityScore {
  elementScore: number;     // Element compatibility (0-100)
  signModifier: number;     // Sign-specific modifier (-20 to +20)
}

// House Compatibility Score
export interface HouseCompatibilityScore {
  total: number;            // Overall house compatibility (0-100)
  partnershipHouse: number; // 7th house compatibility
  romanceHouse: number;     // 5th house compatibility
  intimacyHouse: number;    // 8th house compatibility
  selfHouse: number;        // 1st house compatibility
}

// Vedic Compatibility Score
export interface VedicCompatibilityScore {
  total: number;           // Overall Vedic compatibility (0-100)
  gunaScore: number;      // Guna compatibility
  nakshatraScore: number; // Nakshatra compatibility
  planetaryScore: number; // Planetary ruler compatibility
}

// Aspect Compatibility Score
export interface AspectCompatibilityScore {
  total: number;           // Overall aspect compatibility (0-100)
  aspectScore: number;     // Raw aspect score
  elementScore: number;    // Element-based score
  aspectDetails: AspectDetail[];
}

// Astrological Compatibility Score
export interface AstrologicalCompatibilityScore {
  total: number;          // Overall astrological compatibility (0-100)
  aspect: AspectCompatibilityScore;
  element: BaseCompatibilityScore;
}

// Enhanced Compatibility Score
export interface CompatibilityScore {
  total: number;          // Overall compatibility (0-100)
  questionnaire: number;  // Questionnaire score (0-100)
  astrological: AstrologicalCompatibilityScore;
}

// Compatibility Details
export interface CompatibilityDetails {
  score: CompatibilityScore;
  astrologicalDetails: string;
  aspectDetails?: string;
  elementDetails?: string;
}

// Natal Chart Data
export interface NatalChartData {
  birthData: BirthData;
  sign: ZodiacSign;
  ascendant?: ZodiacSign;
  moonSign?: ZodiacSign;
  housePositions?: HousePosition[];
  vedicAttributes?: VedicAttributes;
  planetPositions?: Record<PlanetaryBody, PlanetPosition>;
}
