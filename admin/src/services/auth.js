import { signInWithEmailAndPassword, signOut } from 'firebase/auth'
import { doc, getDoc } from 'firebase/firestore'
import { auth, db } from './firebase'

/**
 * Connexion admin : vérifie Firebase Auth puis role == "admin" dans Firestore
 */
export const loginAdmin = async (email, password) => {
  const { user } = await signInWithEmailAndPassword(auth, email, password)

  const userDoc = await getDoc(doc(db, 'users', user.uid))
  if (!userDoc.exists() || userDoc.data().role !== 'admin') {
    await signOut(auth)
    throw new Error("Accès non autorisé. Vous n'êtes pas administrateur.")
  }

  return user
}

export const logoutAdmin = () => signOut(auth)

/** Retourne le token Firebase courant (pour les requêtes API) */
export const getIdToken = () => auth.currentUser?.getIdToken()
