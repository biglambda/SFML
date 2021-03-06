{-# LANGUAGE CPP, ForeignFunctionInterface #-}
module SFML.System.Clock
(
    Clock(..)
,   createClock
,   copy
,   destroy
,   getElapsedTime
,   restartClock
)
where


import SFML.SFCopyable
import SFML.SFResource
import SFML.System.Time

import Foreign.Marshal.Alloc (alloca)
import Foreign.Ptr
import Foreign.Storable (peek)


newtype Clock = Clock (Ptr Clock)


-- | Create a new clock and start it.
createClock :: IO Clock
createClock = sfClock_create

foreign import ccall unsafe "sfClock_create"
    sfClock_create :: IO Clock

--CSFML_SYSTEM_API sfClock* sfClock_create(void);


instance SFCopyable Clock where
    
    {-# INLINABLE copy #-}
    copy = sfClock_copy


foreign import ccall unsafe "sfClock_copy"
    sfClock_copy :: Clock -> IO Clock

--CSFML_SYSTEM_API sfClock* sfClock_copy(sfClock* clock);


instance SFResource Clock where
    
    {-# INLINABLE destroy #-}
    destroy = sfClock_destroy

foreign import ccall unsafe "sfClock_destroy"
    sfClock_destroy :: Clock -> IO ()

--CSFML_SYSTEM_API void sfClock_destroy(sfClock* clock);


-- | Get the time elapsed in a clock.
--
-- This function returns the time elapsed since the last call
-- to sfClock_restart (or the construction of the object if
-- sfClock_restart has not been called).

getElapsedTime :: Clock -> IO Time
getElapsedTime clock = alloca $ \ptr -> sfClock_getElapsedTime_helper clock ptr >> peek ptr

foreign import ccall unsafe "sfClock_getElapsedTime_helper"
    sfClock_getElapsedTime_helper :: Clock -> Ptr Time -> IO ()

--CSFML_SYSTEM_API sfTime sfClock_getElapsedTime(const sfClock* clock);


-- | Restart a clock.
--
-- This function puts the time counter back to zero.
-- It also returns the time elapsed since the clock was started.

restartClock :: Clock -> IO Time
restartClock clock = alloca $ \ptr -> sfClock_restart_helper clock ptr >> peek ptr

foreign import ccall unsafe "sfClock_restart_helper"
    sfClock_restart_helper :: Clock -> Ptr Time -> IO ()

--CSFML_SYSTEM_API sfTime sfClock_restart(sfClock* clock);

