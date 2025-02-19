import { Profile } from '../types/database';
import {
  QuestionnaireCompatibility,
  CategoryScore,
  MATCH_SCORES,
  CATEGORY_WEIGHTS,
  RATING_CATEGORIES
} from '../types/compatibility';

type RatingType = 'values' | 'lifestyle' | 'personality';

function compareRatings(
  rating1: number,
  rating2: number,
  threshold: number = 2
): number {
  const difference = Math.abs(rating1 - rating2);
  
  if (difference <= 1) {
    return MATCH_SCORES.EXACT;
  } else if (difference <= threshold) {
    return MATCH_SCORES.COMPLEMENTARY;
  } else if (difference <= threshold + 1) {
    return MATCH_SCORES.NEUTRAL;
  }
  return MATCH_SCORES.OPPOSING;
}

function calculateCategoryRatingScore(
  profile1: Profile,
  profile2: Profile,
  ratingType: RatingType,
  ratingKeys: string[]
): number {
  const getRatings = (profile: Profile, type: RatingType) => {
    switch (type) {
      case 'values':
        return profile.values_ratings;
      case 'lifestyle':
        return profile.lifestyle_ratings;
      case 'personality':
        return profile.personality_ratings;
    }
  };

  const ratings1 = getRatings(profile1, ratingType);
  const ratings2 = getRatings(profile2, ratingType);

  if (!ratings1 || !ratings2) return 0;

  const scores = ratingKeys.map(key => {
    if (ratings1[key] === undefined || ratings2[key] === undefined) {
      return 0;
    }
    return compareRatings(ratings1[key], ratings2[key]);
  });

  return scores.reduce((sum, score) => sum + score, 0) / scores.length;
}

function calculateCategoryScore(
  profile1: Profile,
  profile2: Profile,
  categoryKey: keyof typeof RATING_CATEGORIES
): CategoryScore {
  const categoryRatings = RATING_CATEGORIES[categoryKey];
  let totalScore = 0;
  let totalFactors = 0;

  // Calculate scores for each rating type in the category
  Object.entries(categoryRatings).forEach(([ratingType, ratingKeys]) => {
    const typeScore = calculateCategoryRatingScore(
      profile1,
      profile2,
      ratingType as RatingType,
      ratingKeys
    );
    totalScore += typeScore;
    totalFactors++;
  });

  // Get the weight for this category
  const weightKey = categoryKey.toUpperCase() as keyof typeof CATEGORY_WEIGHTS;
  const weight = CATEGORY_WEIGHTS[weightKey];

  return {
    score: totalFactors > 0 ? totalScore / totalFactors : 0,
    weight
  };
}

// Calculate questionnaire compatibility (50% of total score)
export function calculateQuestionnaireCompatibility(
  profile1: Profile,
  profile2: Profile
): QuestionnaireCompatibility {
  // Calculate scores for each category
  const coreValues = calculateCategoryScore(profile1, profile2, 'coreValues');
  const relationshipApproach = calculateCategoryScore(profile1, profile2, 'relationshipApproach');
  const communicationConflict = calculateCategoryScore(profile1, profile2, 'communicationConflict');
  const emotionalSocial = calculateCategoryScore(profile1, profile2, 'emotionalSocial');
  const personalCharacteristics = calculateCategoryScore(profile1, profile2, 'personalCharacteristics');

  // Calculate total weighted score (out of 50)
  const total = Object.values({
    coreValues,
    relationshipApproach,
    communicationConflict,
    emotionalSocial,
    personalCharacteristics
  }).reduce((sum, category) => {
    return sum + (category.score * category.weight * 50);
  }, 0);

  return {
    coreValues,
    relationshipApproach,
    communicationConflict,
    emotionalSocial,
    personalCharacteristics,
    total
  };
}

// Calculate and update match scores
export async function updateMatchScores(
  match: { id: string; user1_id: string; user2_id: string },
  profile1: Profile,
  profile2: Profile
): Promise<{ 
  compatibility_score: number;
  questionnaire_score: number;
  astrological_score: number;
}> {
  // Calculate questionnaire compatibility (50% of total)
  const questionnaireResult = calculateQuestionnaireCompatibility(profile1, profile2);
  const questionnaireScore = questionnaireResult.total / 50; // Convert to 0-1 scale

  // For now, we'll use a placeholder for astrological score
  // This will be replaced with actual calculation later
  const astrologicalScore = 0.5; // Placeholder 50% score

  // Calculate total compatibility score
  // Currently: 50% questionnaire + 50% astrological (placeholder)
  const compatibilityScore = (questionnaireScore * 0.5) + (astrologicalScore * 0.5);

  return {
    compatibility_score: compatibilityScore,
    questionnaire_score: questionnaireScore,
    astrological_score: astrologicalScore
  };
}
