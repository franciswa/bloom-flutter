import { 
  CompatibilityScore, 
  CompatibilityDetails,
  ZodiacSign,
  PlanetaryBody,
  NatalChart,
  BaseCompatibilityScore,
  AstrologicalCompatibilityScore,
  BirthData
} from '../types/compatibility';
import { createNatalChart, getDefaultPlanetPositions } from './birthData';
import { calculateAstrologicalCompatibility, getAstrologicalCompatibilityDetails } from './astrological';
import { calculateAspectCompatibility, getAspectDetails } from './aspects';

// Calculate astrological compatibility (50% of total)
function calculateAstrologicalScore(
  birthData1: BirthData,
  birthData2: BirthData
): AstrologicalCompatibilityScore {
  // Create natal charts from birth data
  const natalData1 = createNatalChart(birthData1);
  const natalData2 = createNatalChart(birthData2);

  const sign1 = natalData1.sign;
  const sign2 = natalData2.sign;

  // Extract natal charts for aspect calculations
  const chart1: NatalChart = {
    planetPositions: natalData1.planetPositions || getDefaultPlanetPositions(sign1)
  };
  const chart2: NatalChart = {
    planetPositions: natalData2.planetPositions || getDefaultPlanetPositions(sign2)
  };

  // Calculate aspect compatibility (25% of astrological)
  const aspectScore = calculateAspectCompatibility(chart1, chart2);

  // Calculate element compatibility (25% of astrological)
  const elementScore = calculateAstrologicalCompatibility(sign1, sign2);

  // Calculate total astrological score
  const total = Math.round(
    (aspectScore.total * 0.5) + 
    ((elementScore.elementScore + elementScore.signModifier) * 0.5)
  );

  return {
    total,
    aspect: aspectScore,
    element: elementScore
  };
}

// Calculate overall compatibility score
export const calculateCompatibility = (
  birthData1: BirthData,
  birthData2: BirthData,
  questionnaireScore?: number
): CompatibilityDetails => {
  // Calculate astrological compatibility (50% of total)
  const astrological = calculateAstrologicalScore(birthData1, birthData2);
  
  // Get signs for details
  const sign1 = createNatalChart(birthData1).sign;
  const sign2 = createNatalChart(birthData2).sign;
  
  // Use provided questionnaire score or default to middle value
  const questionnaire = questionnaireScore ?? 50;

  // Calculate total score (50% questionnaire, 50% astrological)
  const total = Math.round((questionnaire * 0.5) + (astrological.total * 0.5));

  // Get detailed explanations
  const astrologicalDetails = getAstrologicalCompatibilityDetails(sign1, sign2);
  const aspectDetails = getAspectDetails(astrological.aspect.aspectDetails);
  const elementDetails = `Element compatibility between ${sign1} and ${sign2}: ${astrological.element.elementScore}%`;

  return {
    score: {
      total,
      questionnaire,
      astrological
    },
    astrologicalDetails,
    aspectDetails,
    elementDetails
  };
};
