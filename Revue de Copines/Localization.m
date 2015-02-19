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
                            @"en" : @"No Internet connection",
                            @"fr" : @"Pas de connexion Internet"
                        },
                        @"you must be connected to the internet" : @{
                            @"en" : @"You must be connected to the Internet to use this app",
                            @"fr" : @"Vous devez être connecté à Internet pour utiliser cette application"
                        },
                        @"ok" : @{
                            @"en" : @"OK",
                            @"fr" : @"Ok"
                        },
                        @"cancel" : @{
                            @"en" : @"Cancel",
                            @"fr" : @"Annuler"
                        },
                        @"error" : @{
                            @"en" : @"Error",
                            @"fr" : @"Erreur"
                        },
                        @"you must choose 3 themes" : @{
                            @"en" : @"You must choose 3 themes",
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
                            @"fr" : @"Qu'est-ce que vous voulez faire ?"
                        },
                        @"take photo" : @{
                            @"en" : @"Take Photo",
                            @"fr" : @"Prendre une photo"
                        },
                        @"select from library" : @{
                            @"en" : @"Select from Library",
                            @"fr" : @"Choisissez parmi Bibliothèque"
                        },
                        @"please type your facebook profile url" : @{
                            @"en" : @"Please type your Facebook profile URL",
                            @"fr" : @"Se il vous plaît entrez votre Facebook profil"
                        },
                        @"please type your twitter profile url" : @{
                            @"en" : @"Please type your Twitter profile URL",
                            @"fr" : @"Se il vous plaît entrez votre Twitter profil"
                                },
                        @"please type your instagram profile url" : @{
                            @"en" : @"Please type your Instagram profile URL",
                            @"fr" : @"Se il vous plaît entrez votre Instagram profil"
                                },
                        @"please type your pinterest profile url" : @{
                            @"en" : @"Please type your Pinterest profile URL",
                            @"fr" : @"Se il vous plaît entrez votre Pinterest profil"
                                },
                        @"please type your google+ profile url" : @{
                            @"en" : @"Please type your Google+ profile URL",
                            @"fr" : @"Se il vous plaît entrez votre Google+ profil"
                                },
                        @"creating account" : @{
                            @"en" : @"Creating Account",
                            @"fr" : @"Création de compte"
                        },
                        @"please wait" : @{
                            @"en" : @"Please Wait...",
                            @"fr" : @"Se il vous plaît patienter ..."
                        },
                        @"name is required" : @{
                            @"en" : @"Name is required",
                            @"fr" : @"Le nom est obligatoire"
                        },
                        @"name should not contain more than 100 chars" : @{
                            @"en" : @"Name should not contain more than 100 characters",
                            @"fr" : @"Nom ne doit pas contenir plus de 100 caractères"
                        },
                        @"email is required" : @{
                            @"en" : @"Email is required",
                            @"fr" : @"Email est obligatoire"
                        },
                        @"email should not contain more than 255 chars" : @{
                            @"en" : @"Email should not contain more than 255 characters",
                            @"fr" : @"Email ne doit pas contenir plus de 255 caractères"
                        },
                        @"password should contain at least 8 chars" : @{
                            @"en" : @"Password should contain at least 8 characters",
                            @"fr" : @"Mot de passe doit contenir au moins 8 caractères"
                        },
                        @"password should not contain more thant 64 chars" : @{
                            @"en" : @"Password should not contain more than 64 characters",
                            @"fr" : @"Mot de passe ne doit pas contenir plus de 64 caractères"
                        },
                        @"email is invalid" : @{
                            @"en" : @"Email is invalid",
                            @"fr" : @"Email est invalide"
                        },
                        @"blog name is required" : @{
                            @"en" : @"Blog Name is required",
                            @"fr" : @"Nom du blog est obligatoire"
                        },
                        @"blog name should not contain more than 100 chars" : @{
                            @"en" : @"Blog Name should not contain more than 100 characters",
                            @"fr" : @"Nom du blog ne doit pas contenir plus de 100 caractères"
                        },
                        @"blog localisation is required" : @{
                            @"en" : @"Blog Localisation is required",
                            @"fr" : @"Blog Localisation est obligatoire"
                        },
                        @"blog localisation should not contain more than 100 chars" : @{
                            @"en" : @"Blog Localisation should not contain more than 100 characters",
                            @"fr" : @"Blog Localisation ne doit pas contenir plus de 100 caractères"
                        },
                        @"blog url is required" : @{
                            @"en" : @"Blog Url is required",
                            @"fr" : @"Blog Url est obligatoire"
                        },
                        @"blog url is invalid" : @{
                            @"en" : @"Blog Url is invalid",
                            @"fr" : @"Blog Url est invalide"
                        },
                        @"blog description is required" : @{
                            @"en" : @"Blog Description is required",
                            @"fr" : @"Blog description est obligatoire"
                        },
                        @"blog description should not contain more than 480 chars" : @{
                            @"en" : @"Blog Description should not contain more than 480 characters",
                            @"fr" : @"Blog description ne doit pas contenir plus de 480 caractères"
                        },
                        @"you need to select at least 1 category" : @{
                            @"en" : @"You need to select at least 1 category",
                            @"fr" : @"Vous devez sélectionner au moins une catégorie"
                        },
                        @"updating categories" : @{
                            @"en" : @"Updating Categories",
                            @"fr" : @"Mise à jour Catégories"
                        },
                        @"password mismatch" : @{
                            @"en" : @"Password mismatch",
                            @"fr" : @"Mot de passe erroné"
                        },
                        @"the passwords don't match" : @{
                            @"en" : @"The passwords don't match",
                            @"fr" : @"Les mots de passe ne correspondent pas"
                        }
                    };
    
    return [[locales objectForKey:text] objectForKey:locale];
}

@end