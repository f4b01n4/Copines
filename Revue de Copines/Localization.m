//
//  Localization.m
//  Revue de Copines
//
//  Created by Fábio Violante on 29/12/14.
//  Copyright (c) 2014 Pears & Bragston. All rights reserved.
//

#import "Localization.h"

@implementation Localization

-(NSString*) getStringForText:(NSString *)text forLocale:(NSString *)locale {
    NSDictionary *locales = @{
                        @"no internet connection" : @{
                            @"en" : @"No internet connection",
                            @"fr" : @"Pas de connexion Internet"
                        },
                        @"you must be connected to the internet" : @{
                            @"en" : @"You must be connected to the Internet to use this app",
                            @"fr" : @"Vous devez être connecté à Internet pour utiliser cette application"
                        },
                        @"ok" : @{
                            @"en" : @"Ok",
                            @"fr" : @"Ok"
                        },
                        @"cancel" : @{
                            @"en" : @"Cancel",
                            @"fr" : @"Annuler"
                        },
                        @"error" : @{
                            @"en" : @"Oops, an error has occured",
                            @"fr" : @"Oups, une erreur est survenue"
                        },
                        @"you must choose 3 themes" : @{
                            @"en" : @"You need to choose 3 topics",
                            @"fr" : @"Vous devez choisir 3 thèmes"
                        },
                        @"you need to select 3 categories" : @{
                            @"en" : @"You need to select 3 categories",
                            @"fr" : @"Vous devez sélectionner 3 catégories"
                        },
                        @"you can only select 3 categories" : @{
                            @"en" : @"You can only select 3 categories",
                            @"fr" : @"Vous ne pouvez sélectionner trois catégories"
                        },
                        @"what do you want to do" : @{
                            @"en" : @"What do you want to do?",
                            @"fr" : @"Que souhaitez-vous faire ?"
                        },
                        @"take photo" : @{
                            @"en" : @"Take a picture",
                            @"fr" : @"Prendre une photo"
                        },
                        @"select from library" : @{
                            @"en" : @"Select from Library",
                            @"fr" : @"Choisissez parmi Bibliothèque"
                        },
                        @"please type your facebook profile url" : @{
                            @"en" : @"Please type your Facebook profile URL",
                            @"fr" : @"Veuillez entrer le lien de votre page Facebook"
                        },
                        @"please type your twitter profile url" : @{
                            @"en" : @"Please type your Twitter profile URL",
                            @"fr" : @"Veuillez entrer le lien de votre page Twitter"
                                },
                        @"please type your instagram profile url" : @{
                            @"en" : @"Please type your Instagram profile URL",
                            @"fr" : @"Veuillez entrer le lien de votre page Instagram"
                                },
                        @"please type your pinterest profile url" : @{
                            @"en" : @"Please type your Pinterest profile URL",
                            @"fr" : @"Veuillez entrer le lien de votre page Pinterest"
                                },
                        @"please type your google+ profile url" : @{
                            @"en" : @"Please type your Google+ profile URL",
                            @"fr" : @"Veuillez entrer le lien de votre page Google Plus"
                                },
                        @"creating account" : @{
                            @"en" : @"Creating Account",
                            @"fr" : @"Création de compte"
                        },
                        @"please wait" : @{
                            @"en" : @"Please wait",
                            @"fr" : @"Veuillez patienter"
                        },
                        @"name is required" : @{
                            @"en" : @"Your name is required",
                            @"fr" : @"Votre nom est obligatoire"
                        },
                        @"name should not contain more than 100 chars" : @{
                            @"en" : @"Your name should not contain more than 100 characters",
                            @"fr" : @"Votre nom ne doit pas contenir plus de 100 caractères"
                        },
                        @"email is required" : @{
                            @"en" : @"Your email is required",
                            @"fr" : @"Vous devez indiquer une adresse email"
                        },
                        @"email should not contain more than 255 chars" : @{
                            @"en" : @"Your email should not contain more than 255 characters",
                            @"fr" : @"Votre email ne doit pas contenir plus de 255 caractères"
                        },
                        @"password should contain at least 8 chars" : @{
                            @"en" : @"Your password should contain at least 8 characters",
                            @"fr" : @"Votre mot de passe doit contenir au moins 8 caractères"
                        },
                        @"password should not contain more thant 64 chars" : @{
                            @"en" : @"Your password should not contain more than 64 characters",
                            @"fr" : @"Votre mot de passe ne doit pas contenir plus de 64 caractères"
                        },
                        @"email is invalid" : @{
                            @"en" : @"Your email address is incorrect",
                            @"fr" : @"Votre email est invalide"
                        },
                        @"blog name is required" : @{
                            @"en" : @"Blog name is required",
                            @"fr" : @"Le nom du blog est obligatoire"
                        },
                        @"blog name should not contain more than 100 chars" : @{
                            @"en" : @"Blog name should not contain more than 100 characters",
                            @"fr" : @"Le nom du blog ne doit pas contenir plus de 100 caractères"
                        },
                        @"blog localisation is required" : @{
                            @"en" : @"You need to indicate your location",
                            @"fr" : @"Vous devez indiquer une localisation"
                        },
                        @"blog localisation should not contain more than 100 chars" : @{
                            @"en" : @"Blog location should not contain more than 100 characters",
                            @"fr" : @"Ne doit pas dépasser 100 caractères"
                        },
                        @"blog url is required" : @{
                            @"en" : @"Blog url is required",
                            @"fr" : @"Vous devez obligatoirement indiquer l'adresse de votre blog"
                        },
                        @"blog url is invalid" : @{
                            @"en" : @"Blog url is incorrect",
                            @"fr" : @"L'adresse de votre blog est invalide"
                        },
                        @"blog description is required" : @{
                            @"en" : @"The blog description is required",
                            @"fr" : @"La description est obligatoire"
                        },
                        @"blog description should not contain more than 480 chars" : @{
                            @"en" : @"The blog description should not contain more than 480 characters",
                            @"fr" : @"La description ne peut contenir plus de 480 caractères"
                        },
                        @"you need to select at least 1 category" : @{
                            @"en" : @"You need to select at least 1 category",
                            @"fr" : @"Vous devez sélectionner au moins une catégorie"
                        },
                        @"updating categories" : @{
                            @"en" : @"Updating your feed",
                            @"fr" : @"Mise à jour de votre feed"
                        },
                        @"password mismatch" : @{
                            @"en" : @"Wrong password",
                            @"fr" : @"Le mot de passe est incorrect"
                        },
                        @"the passwords don't match" : @{
                            @"en" : @"The passwords do not match",
                            @"fr" : @"Les mots de passe ne correspondent pas"
                        },
                        @"register" : @{
                            @"en" : @"Register",
                            @"fr" : @"S'inscrire"
                        },
                        @"register2" : @{
                            @"en" : @"Register",
                            @"fr" : @"Enregistrer"
                        },
                        @"new articles" : @{
                            @"en" : @"new articles",
                            @"fr" : @"nouveaux articles"
                        },
                        @"discover" : @{
                            @"en" : @"Discover",
                            @"fr" : @"Découvrir"
                        },
                        @"add categories" : @{
                            @"en" : @"Add categories",
                            @"fr" : @"Ajouter des catégories"
                        },
                        @"my copines" : @{
                            @"en" : @"My Copines",
                            @"fr" : @"Mes Copines"
                        },
                        @"by" : @{
                            @"en" : @"By",
                            @"fr" : @"Par"
                        },
                        @"done" : @{
                            @"en" : @"Done",
                            @"fr" : @"Terminé"
                        },
                        @"comments" : @{
                            @"en" : @"Comments",
                            @"fr" : @"Commentaires"
                        },
                        @"add a comment" : @{
                            @"en" : @"Add a comment",
                            @"fr" : @"Ajouter un commentaire"
                        },
                        @"search" : @{
                            @"en" : @"Search",
                            @"fr" : @"Rechercher"
                        },
                        @"manage my blog" : @{
                            @"en" : @"Manage my blog",
                            @"fr" : @"Gérer mon blog"
                        },
                        @"manage my profile" : @{
                            @"en" : @"Manage my profile",
                            @"fr" : @"Gérer mon profil"
                        }
                    };
    
    return [[locales objectForKey:text] objectForKey:locale];
}

@end