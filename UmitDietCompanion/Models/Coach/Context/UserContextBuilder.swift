//
//  UserContextBuilder.swift
//  UmitDietCompanion
//

import Foundation

struct UserContextBuilder {

    func build(
        snapshot: DailyHealthSnapshot
    ) -> UserContext {

        UserContext(

            profile: snapshot.profile,

            preferences: snapshot.profile.preferences,

            coaching: snapshot.profile.coaching,

            learned: snapshot.profile.learned

        )

    }

}
