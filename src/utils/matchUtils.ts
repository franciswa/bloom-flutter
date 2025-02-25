import { Match, Profile } from '../types/database';
import { calculateProfileCompatibility } from '../services/compatibility';
import { ExtendedProfile } from '../services/questionnaireCompatibility';

/**
 * Calculate compatibility details for a match
 * @param userProfile Current user's profile
 * @param partnerProfile Partner's profile
 * @returns Compatibility details object
 */
export function calculateMatchCompatibility(
  userProfile: Profile,
  partnerProfile: Profile
): {
  zodiac_compatibility: number;
  personality_match: number;
  lifestyle_match: number;
  values_match: number;
  overall_compatibility: number;
} {
  // Convert to ExtendedProfile type
  const extendedUserProfile = userProfile as ExtendedProfile;
  const extendedPartnerProfile = partnerProfile as ExtendedProfile;
  
  // Calculate compatibility
  const compatibility = calculateProfileCompatibility(
    extendedUserProfile,
    extendedPartnerProfile
  );
  
  return {
    zodiac_compatibility: compatibility.score.astrological.total,
    personality_match: compatibility.questionnaireDetails.personality,
    lifestyle_match: compatibility.questionnaireDetails.lifestyle,
    values_match: compatibility.questionnaireDetails.values,
    overall_compatibility: compatibility.score.total
  };
}

/**
 * Enhance a match with compatibility details
 * @param match Match object
 * @param userProfile Current user's profile
 * @returns Match with compatibility details
 */
export function enhanceMatchWithCompatibility(
  match: Match & { partner_profile: Partial<Profile> },
  userProfile: Profile
): Match & { 
  partner_profile: Partial<Profile>;
  compatibility_details: {
    zodiac_compatibility: number;
    personality_match: number;
    lifestyle_match: number;
    values_match: number;
    overall_compatibility: number;
  };
} {
  // If partner profile is incomplete, return match with default compatibility
  if (!match.partner_profile || !match.partner_profile.personality_ratings) {
    return {
      ...match,
      compatibility_details: {
        zodiac_compatibility: 50,
        personality_match: 50,
        lifestyle_match: 50,
        values_match: 50,
        overall_compatibility: 50
      }
    };
  }
  
  // Calculate compatibility
  const compatibility = calculateMatchCompatibility(
    userProfile,
    match.partner_profile as Profile
  );
  
  // Return enhanced match
  return {
    ...match,
    compatibility_details: compatibility
  };
}
