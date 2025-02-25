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
import { Profile } from '../types/database';
import { createNatalChartSync, getDefaultPlanetPositions } from './birthData';
import { calculateAstrologicalCompatibility, getAstrologicalCompatibilityDetails } from './astrological';
import { calculateAspectCompatibility, getAspectDetails } from './aspects';
import { calculateQuestionnaireCompatibility, ExtendedProfile } from './questionnaireCompatibility';

// Calculate astrological compatibility (50% of total)
function calculateAstrologicalScore(
  birthData1: BirthData,
  birthData2: BirthData
): AstrologicalCompatibilityScore {
  // Create natal charts from birth data
  const natalData1 = createNatalChartSync(birthData1);
  const natalData2 = createNatalChartSync(birthData2);

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
  const compatibilityScore = calculateAstrologicalCompatibility(sign1, sign2);
  const elementScore = compatibilityScore.astrological.element;

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

/**
 * Calculate overall compatibility score using birth data and optional questionnaire score
 * @param birthData1 First user's birth data
 * @param birthData2 Second user's birth data
 * @param questionnaireScore Optional questionnaire score (0-100)
 * @returns Compatibility details
 */
export const calculateCompatibility = (
  birthData1: BirthData,
  birthData2: BirthData,
  questionnaireScore?: number
): CompatibilityDetails => {
  // Calculate astrological compatibility (50% of total)
  const astrological = calculateAstrologicalScore(birthData1, birthData2);
  
  // Get signs for details
  const sign1 = createNatalChartSync(birthData1).sign;
  const sign2 = createNatalChartSync(birthData2).sign;
  
  // Use provided questionnaire score or default to middle value
  const questionnaire = questionnaireScore ?? 50;

  // Calculate total score (50% questionnaire, 50% astrological)
  const total = Math.round((questionnaire * 0.5) + (astrological.total * 0.5));

  // Get detailed explanations
  const astroDetails = getAstrologicalCompatibilityDetails(sign1, sign2);
  const astrologicalDetails = `Compatibility between ${sign1} and ${sign2}: ${astroDetails.elements.length > 0 ? astroDetails.elements.join(', ') : 'Good match'}`;
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

/**
 * Calculate overall compatibility score using profile data
 * @param profile1 First user's profile
 * @param profile2 Second user's profile
 * @returns Compatibility details
 */
export const calculateProfileCompatibility = (
  profile1: ExtendedProfile,
  profile2: ExtendedProfile
): CompatibilityDetails & {
  questionnaireDetails: {
    personality: number;
    lifestyle: number;
    values: number;
    multipleChoice: number;
  }
} => {
  // Convert profile birth data to BirthData format
  const birthData1: BirthData = {
    date: new Date(profile1.birth_date || new Date()),
    time: profile1.birth_time || '12:00',
    latitude: profile1.birth_location?.latitude || 0,
    longitude: profile1.birth_location?.longitude || 0,
    timezone: 'UTC' // Default timezone
  };

  const birthData2: BirthData = {
    date: new Date(profile2.birth_date || new Date()),
    time: profile2.birth_time || '12:00',
    latitude: profile2.birth_location?.latitude || 0,
    longitude: profile2.birth_location?.longitude || 0,
    timezone: 'UTC' // Default timezone
  };

  // Calculate questionnaire compatibility
  const questionnaireResult = calculateQuestionnaireCompatibility(profile1, profile2);
  
  // Calculate astrological compatibility
  const compatibilityDetails = calculateCompatibility(
    birthData1,
    birthData2,
    questionnaireResult.total
  );

  // Return combined results
  return {
    ...compatibilityDetails,
    questionnaireDetails: {
      personality: questionnaireResult.personality,
      lifestyle: questionnaireResult.lifestyle,
      values: questionnaireResult.values,
      multipleChoice: questionnaireResult.multipleChoice
    }
  };
};
