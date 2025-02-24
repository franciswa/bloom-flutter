import { 
  AspectType, 
  PlanetaryBody, 
  NatalChart, 
  AspectDetail,
  AspectCompatibilityScore
} from '../types/compatibility';

// Planet weights for compatibility calculations
const planetWeights: Record<PlanetaryBody, number> = {
  Sun: 1.0,
  Moon: 1.0,
  Mercury: 0.8,
  Venus: 0.9,
  Mars: 0.8,
  Jupiter: 0.7,
  Saturn: 0.7
};

// Allowable deviation from exact aspect angles
const aspectOrbs: Record<AspectType, number> = {
  [AspectType.CONJUNCTION]: 10,
  [AspectType.SEXTILE]: 6,
  [AspectType.SQUARE]: 8,
  [AspectType.TRINE]: 8,
  [AspectType.OPPOSITION]: 10
};

// Aspect strength modifiers
const aspectWeights: Record<AspectType, number> = {
  [AspectType.CONJUNCTION]: 1.0,
  [AspectType.SEXTILE]: 0.5,
  [AspectType.SQUARE]: -0.5,
  [AspectType.TRINE]: 0.8,
  [AspectType.OPPOSITION]: -0.7
};

// Calculate aspect type and strength based on angle
function calculateAspectScore(angle: number): [AspectType | null, number] {
  // Normalize angle to 0-360 range
  angle = angle % 360;
  if (angle > 180) {
    angle = 360 - angle;
  }

  // Check each aspect type
  for (const aspectType of Object.values(AspectType)) {
    if (typeof aspectType === 'number') { // Filter out reverse mappings
      const orb = aspectOrbs[aspectType];
      if (Math.abs(angle - aspectType) <= orb) {
        // Calculate strength based on exactness of aspect
        const strength = 1 - (Math.abs(angle - aspectType) / orb);
        return [aspectType, strength * aspectWeights[aspectType]];
      }
    }
  }

  return [null, 0];
}

// Calculate aspects between two natal charts
export function calculateAspects(chart1: NatalChart, chart2: NatalChart): AspectDetail[] {
  const aspects: AspectDetail[] = [];

  for (const [p1Name, p1Data] of Object.entries(chart1.planetPositions)) {
    for (const [p2Name, p2Data] of Object.entries(chart2.planetPositions)) {
      // Calculate angle between planets
      const angle = Math.abs(p1Data.degree - p2Data.degree);
      
      // Get aspect type and score
      const [aspectType, score] = calculateAspectScore(angle);
      
      if (aspectType !== null) {
        aspects.push({
          planet1: p1Name as PlanetaryBody,
          planet2: p2Name as PlanetaryBody,
          aspectType,
          score
        });
      }
    }
  }

  return aspects;
}

// Calculate overall aspect compatibility score
export function calculateAspectCompatibility(chart1: NatalChart, chart2: NatalChart): AspectCompatibilityScore {
  const aspects = calculateAspects(chart1, chart2);
  let totalScore = 0;
  let totalWeight = 0;

  // Calculate weighted aspect scores
  for (const aspect of aspects) {
    const weight = planetWeights[aspect.planet1] * planetWeights[aspect.planet2];
    totalScore += aspect.score * weight;
    totalWeight += weight;
  }

  // Normalize score to 0-100 range
  const aspectScore = ((totalScore / totalWeight) + 1) * 50;
  
  // Calculate element-based score (placeholder - will be integrated with existing element calculations)
  const elementScore = 75; // Default middle-range score

  return {
    total: Math.round((aspectScore + elementScore) / 2),
    aspectScore: Math.round(aspectScore),
    elementScore,
    aspectDetails: aspects
  };
}

// Generate aspect details text
export function getAspectDetails(aspects: AspectDetail[]): string {
  let details = "Planetary Aspects:\n\n";
  
  // Filter for significant aspects
  const significantAspects = aspects.filter(aspect => Math.abs(aspect.score) > 0.5);
  
  for (const aspect of significantAspects) {
    const strength = Math.abs(aspect.score) * 100;
    const type = aspect.aspectType.toString();
    details += `${aspect.planet1} ${type} ${aspect.planet2}: ${Math.round(strength)}% strength\n`;
  }
  
  return details;
}
