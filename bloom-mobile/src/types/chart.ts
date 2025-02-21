export interface ChartData {
  planets: PlanetPosition[];
  houses: HousePosition[];
  aspects: Aspect[];
  angles: Angles;
}

export interface PlanetPosition {
  planet: Planet;
  sign: ZodiacSign;
  degree: number;
  minute: number;
  house: number;
  speed: number;  // For retrograde detection
  longitude: number;
  latitude: number;
}

export interface HousePosition {
  house: number;
  sign: ZodiacSign;
  degree: number;
  minute: number;
  cusp: number;
}

export interface Aspect {
  planet1: Planet;
  planet2: Planet;
  type: AspectType;
  orb: number;
  exact: boolean;
  applying: boolean;
}

export interface Angles {
  ascendant: number;
  midheaven: number;
  descendant: number;
  imumCoeli: number;
}

export type Planet =
  | 'sun'
  | 'moon'
  | 'mercury'
  | 'venus'
  | 'mars'
  | 'jupiter'
  | 'saturn'
  | 'uranus'
  | 'neptune'
  | 'pluto';

export type ZodiacSign =
  | 'aries'
  | 'taurus'
  | 'gemini'
  | 'cancer'
  | 'leo'
  | 'virgo'
  | 'libra'
  | 'scorpio'
  | 'sagittarius'
  | 'capricorn'
  | 'aquarius'
  | 'pisces';

export type AspectType =
  | 'conjunction'     // 0°
  | 'sextile'        // 60°
  | 'square'         // 90°
  | 'trine'          // 120°
  | 'opposition';    // 180°

export const ZODIAC_SIGNS: Record<ZodiacSign, { symbol: string; label: string; degree: number }> = {
  aries: { symbol: '♈', label: 'Aries', degree: 0 },
  taurus: { symbol: '♉', label: 'Taurus', degree: 30 },
  gemini: { symbol: '♊', label: 'Gemini', degree: 60 },
  cancer: { symbol: '♋', label: 'Cancer', degree: 90 },
  leo: { symbol: '♌', label: 'Leo', degree: 120 },
  virgo: { symbol: '♍', label: 'Virgo', degree: 150 },
  libra: { symbol: '♎', label: 'Libra', degree: 180 },
  scorpio: { symbol: '♏', label: 'Scorpio', degree: 210 },
  sagittarius: { symbol: '♐', label: 'Sagittarius', degree: 240 },
  capricorn: { symbol: '♑', label: 'Capricorn', degree: 270 },
  aquarius: { symbol: '♒', label: 'Aquarius', degree: 300 },
  pisces: { symbol: '♓', label: 'Pisces', degree: 330 }
};

export const PLANETS: Record<Planet, { symbol: string; label: string; color: string }> = {
  sun: { symbol: '☉', label: 'Sun', color: '$yellow8' },
  moon: { symbol: '☽', label: 'Moon', color: '$blue8' },
  mercury: { symbol: '☿', label: 'Mercury', color: '$purple8' },
  venus: { symbol: '♀', label: 'Venus', color: '$green8' },
  mars: { symbol: '♂', label: 'Mars', color: '$red8' },
  jupiter: { symbol: '♃', label: 'Jupiter', color: '$orange8' },
  saturn: { symbol: '♄', label: 'Saturn', color: '$gray8' },
  uranus: { symbol: '♅', label: 'Uranus', color: '$cyan8' },
  neptune: { symbol: '♆', label: 'Neptune', color: '$indigo8' },
  pluto: { symbol: '♇', label: 'Pluto', color: '$violet8' }
};

export const ASPECT_TYPES: Record<AspectType, { angle: number; orb: number; color: string }> = {
  conjunction: { angle: 0, orb: 8, color: '$green8' },
  sextile: { angle: 60, orb: 6, color: '$purple8' },
  square: { angle: 90, orb: 8, color: '$red8' },
  trine: { angle: 120, orb: 8, color: '$blue8' },
  opposition: { angle: 180, orb: 8, color: '$orange8' }
};
